import 'package:flutter/material.dart';
import '../models/especie.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
//debug
import 'package:flutter/foundation.dart';

import '../../../backend/llamadasRemotas/llamadasFlora.dart';
import '../../../backend/llamadasLocales/llamadasFlora.dart';

import '../../../validarRed.dart';

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool get cargandoData => _cargandoData;
  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  /*Future<void> cargarFlora() async {
    if (kIsWeb) {
      await cargarFloraR();
    } else if (Platform.isAndroid || Platform.isIOS) {
      await cargarFloraL();
    } else {
      await cargarFloraR();
    }
  }*/
  Future<void> cargarFlora() async {
    // 🌐 Web siempre usa remoto
    if (kIsWeb) {
      await cargarFloraR();
      return;
    }

    // 📱 Mobile
    if (Platform.isAndroid || Platform.isIOS) {
      final bool hayInternet = await validarRed();

      if (hayInternet) {
        debugPrint('[FLORA] cargando remoto');
        await cargarFloraR();
      } else {
        debugPrint('[FLORA] cargando local');
        await cargarFloraL();
      }
      return;
    }

    // 🖥️ Otros (desktop, fallback)
    await cargarFloraR();
  }

  Future<void> insertar(Especie nueva) async {
    if (kIsWeb) {
      await insertarR(nueva);
    } else if (Platform.isAndroid || Platform.isIOS) {
      await insertarL(nueva);

      // Aquí podrías añadir una validación de internet para
      // disparar la sincronización inmediatamente si hay red
    }
  }

  Future<void> cargarFloraR() async {
    _cargandoData = true;
    notifyListeners();
    try {
      final especiesBD = await getFlora().timeout(Duration(seconds: 20));
      _especies.clear();

      if (especiesBD['ok'] == true) {
        final List<Especie> resultadoFormateado =
            (especiesBD['respuesta'] as List<dynamic>)
                .map<Especie>((fila) => Especie.jsonToEspecie(fila))
                .toList();
        print('El resultado  del get: ${resultadoFormateado}');
        _especies.addAll(resultadoFormateado);
      } else {
        print('La consulta GET salio mal');
        print('$especiesBD');
      }

      _cargandoData = false;
      notifyListeners();
    } on TimeoutException catch (_) {
      print('La operación tardó demasiado');
      _cargandoData = false;
      notifyListeners();
    }
  }

  Future<void> cargarFloraL() async {
    _cargandoData = true;
    notifyListeners();
    try {
      final respuesta = await cargarFloraLocal();
      _especies.clear();
      for (var mapa in respuesta) {
        _especies.add(Especie.fromLocal(mapa));
      }
    } catch (e) {
      print(e);
    } finally {
      _cargandoData = false;
      notifyListeners();
    }
  }

  List<Especie> get especiesFiltradas {
    if (_filtro == 'all') return _especies;
    List<Especie> _especiesFiltradas = [];
    if (_filtro == 'Flor distintiva') {
      _especiesFiltradas =
          _especies.where((e) => e.florDistintiva != null).toList();
    }
    if (_filtro == 'Fruta distintiva') {
      _especiesFiltradas =
          _especies.where((e) => e.frutaDistintiva != null).toList();
    }
    if (_filtro == 'Salud del suelo') {
      _especiesFiltradas = _especies.where((e) => e.saludSuelo == 1).toList();
    }
    return _especiesFiltradas;
  }

  void setFiltro(String valor) {
    _filtro = valor;
    notifyListeners();
  }

  Future<void> eliminar(String nombreCientifico) async {
    try {
      final resp = await deleteFlora(nombreCientifico);
      if (resp) {
        print('datos eliminado en bd');
        _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);
      } else {
        print('no se elimino en bd');
      }
    } catch (e) {
      print('$e');
    }

    notifyListeners();
  }

  Future<bool> update(Especie fila) async {
    final List<String> urlsSubidas = [];
    try {
      if (fila.imagenes.isNotEmpty) {
        for (final img in fila.imagenes) {
          if (img.bytes != null) {
            print('llamando a imagen');
            final String url = await insertImagen(
              img.bytes!,
              fila.nombreCientifico,
            );
            if (url.isEmpty) throw Exception('Error al subir imagen');
            urlsSubidas.add(url);
            img.urlFoto = url;
            img.bytes = null;
          }
        }
      }

      final resp = await updateFlora(fila);
      if (!resp) throw Exception('Falló la inserción en BD');
      if (resp) {
        //_especies.add(fila);
        print('datos actualizados en bd');
      }
      notifyListeners();
      return resp;
    } catch (e) {
      print(e);
      for (final u in urlsSubidas) {
        await deleteImagen(u);
      }
      return false;
    }
  }

  Future<void> insertarR(Especie nueva) async {
    final List<String> urlsSubidas = [];
    try {
      for (final img in nueva.imagenes) {
        if (img.bytes == null) {
          throw Exception('Imagen no seleccionada correctamente');
        }
        final String url = await insertImagen(
          img.bytes!,
          nueva.nombreCientifico,
        );
        if (url.isEmpty) throw Exception('Error al subir imagen');
        urlsSubidas.add(url);
        img.urlFoto = url;
        img.bytes = null;
      }

      final resp = await insertFloraRemoto(nueva);
      if (!resp) throw Exception('Falló la inserción en BD');
      _especies.add(nueva);
      print('datos insertados en bd');
    } catch (e) {
      print('Error en insertar: $e');
      for (final u in urlsSubidas) {
        await deleteImagen(u);
      }
      rethrow;
    }
    notifyListeners();
  }

  //insert offline-first

  Future<void> insertarL(Especie nuevaEspecie) async {
    try {
      bool guardadoLocal = await insertFloraLocal([nuevaEspecie.toJson()]);

      if (guardadoLocal) {
        cargarFloraL();

        // 2. INTENTAR SINCRONIZAR (Opcional/Segundo plano)
        // No bloqueamos al usuario. Si hay internet, se envía; si no, queda en SQLite.
        //_intentarSincronizarRemoto(nuevaEspecie);
      }
    } catch (e) {
      print(e);
    }
  }

  void normalizarEspecie(Especie especie) {
    // Creamos nuevas listas filtradas (Inmutabilidad)
    especie.nombresComunes =
        especie.nombresComunes
            .where((e) => e.nombres.trim().isNotEmpty)
            .toList();

    especie.utilidades =
        especie.utilidades.where((e) => e.utilpara.trim().isNotEmpty).toList();

    especie.origenes =
        especie.origenes.where((e) => e.origen.trim().isNotEmpty).toList();

    especie.imagenes =
        especie.imagenes
            .where((e) => e.bytes != null || e.urlFoto.trim().isNotEmpty)
            .toList();
  }
}
