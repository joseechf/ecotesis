import 'package:flutter/material.dart';
import '../models/especie.dart';
import 'dart:async';

import '../../../backend/llamadasRemotas/llamadasFlora.dart';

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool get cargandoData => _cargandoData;
  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

  Future<void> cargarFlora() async {
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
        //resultadoFormateado.map((fila) => _especies.addAll(fila));
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

  Future<bool> update(Map<String, dynamic> fila) async {
    print(fila);

    try {
      if ((fila['imagenes'] != null) && (fila['imagenes'] as List).isNotEmpty) {
        for (final img in fila['imagenes']) {
          if (img.bytes != null) {
            print('llamando a imagen');
            final url = await insertImagen(
              img.bytes!,
              fila['nombreCientifico'],
            );
            img.urlFoto = url;
            img.bytes = null;
          }
        }
      }

      final resp = await updateFlora(fila);

      if (resp) {
        //_especies.add(nueva);
        print('datos actualizados en bd');
      }
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> insertar(Especie nueva) async {
    try {
      for (final img in nueva.imagenes) {
        if (img.bytes != null) {
          print('llamando a imagen');
          final url = await insertImagen(img.bytes!, nueva.nombreCientifico);
          img.urlFoto = url;
          img.bytes = null;
        } else {
          print('bytes = null');
          throw Exception('La imagen no se selecciono correctamente');
        }
      }

      final resp = await insertFlora(nueva);

      if (resp) {
        _especies.add(nueva);
        print('datos insertados en bd');
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void limpiarVectores(Especie especie) {
    especie.nombresComunes.removeWhere((e) => e.nombres.trim().isEmpty);

    especie.utilidades.removeWhere((e) => e.utilpara.trim().isEmpty);

    especie.origenes.removeWhere((e) => e.origen.trim().isEmpty);

    especie.imagenes.removeWhere(
      (e) => e.bytes == null && e.urlFoto.trim().isEmpty,
    );
  }
}
