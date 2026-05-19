import '../../../domain/entities/especie_unificada.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import '../../../backend/llamadas_remotas/llamadas_flora.dart';
import '../../../backend/llamadas_locales/llamadas_flora.dart';
import '../../../backend/llamadas_locales/sqlite_helper.dart';
import '../../../validar_red.dart';
import '../../../domain/value_objects.dart';
import '../../../backend/libSinc/sincronizacion.dart';
import '../../iureutilizables/errores.dart';
class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool _insertando = false;
  OnError? _error;
  OnError? get error => _error;
  bool sincronizando = false;
  bool get cargandoData => _cargandoData;
  List<Especie> get especies => _especies;
  final Set<String> _filtrosActivos = {};
  Set<String> get filtrosActivos => _filtrosActivos;

  Future<String> _elegirBD() async {
    if (kIsWeb) return 'remoto';
    if (Platform.isAndroid || Platform.isIOS) {
      final hayInternet = await validarRed();
      return hayInternet ? 'remoto' : 'local';
    }
    return 'remoto';
  }

Future<void> cargarFlora() async {
  final destino = await _elegirBD();

  _cargandoData = true;
  _error = null;
  notifyListeners();

  try {
    _especies.clear();

    if (destino == 'remoto') {
      final response = await getFlora(
        endpoint: 'getflora',
      ).timeout(const Duration(seconds: 20));

      _especies.addAll(
        response.map<Especie>((json) => Especie.fromJson(json)).toList(),
      );
    } else {
      final db = await dbLocal.instancia;
      final especies = await cargarFloraLocal(db);
      _especies.addAll(especies);
    }
  } on OnError catch (e) {
    _error = e;
    debugPrint('ERROR PROVIDER cargarFlora: ${e.type} | ${e.message}');
  } catch (e) {
    _error = OnError(
      type: 'provider',
      message: e.toString(),
      source: 'cargarFlora',
    );
    debugPrint('ERROR PROVIDER cargarFlora: $e');
  } finally {
    _cargandoData = false;
    notifyListeners();
  }
}

Future<bool> insertar(Especie nueva, {List<Uint8List>? imgsBytes}) async {
  if (_insertando) return false;

  _insertando = true;
  _error = null;

  try {
    final destino = await _elegirBD();

    if (destino == 'remoto') {
      try {
        if (imgsBytes != null) {
          await _insertarRemoto(nueva, imgsBytes);
        } else {
          await insertAPI(nueva.toJson(), 'insertflora');
        }

      } on OnError catch (e) {
        debugPrint('ERROR INSERTAR REMOTO: ${e.source} | ${e.type} | ${e.message}');
        //si el insert falla puede ser por softdelete, se actualiza el registro, si no existe tambien va a fallar,si existe se revive
        debugPrint('intentando revivir el registro ${nueva.nombreCientifico}');
        if (imgsBytes != null) {
          await _updateRemoto(nueva, imgsBytes);
        } else {
          await updateFloraRemoto(nueva.toJson());
        }
      }
    } else {
      final db = await dbLocal.instancia;
      final duplicado = await obtenerFloraLocalById(
        db,
        nueva.nombreCientifico,
      );

      if (duplicado != null) {
        await updateFloraLocal(db, nueva);
      } else {
        await _insertarLocal(nueva);
      }
    }

    await cargarFlora();
    return true;
  } on OnError catch (e) {
    _error = e;
    debugPrint('ERROR PROVIDER insertar: ${e.source} | ${e.type} | ${e.message}');
    return false;
  } catch (e) {
    _error = OnError(
      type: 'provider',
      message: e.toString(),
      source: 'insertar',
    );

    debugPrint('ERROR PROVIDER insertar: $e');
    return false;
  } finally {
    _insertando = false;
    notifyListeners();
  }
}

Future<bool> update(Especie nueva, {List<Uint8List>? imgsBytes}) async {
  _cargandoData = true;
  _error = null;
  notifyListeners();

  try {
    final destino = await _elegirBD();

    if (destino == 'remoto') {
      await _updateRemoto(nueva, imgsBytes ?? []);
    } else {
      final ok = await _updateLocal(nueva);

      if (!ok) {
        throw OnError(
          type: 'local',
          message: 'Error actualizando local',
          source: 'update',
        );
      }
    }

    return true;
  } on OnError catch (e) {
    _error = e;
    debugPrint('ERROR PROVIDER update: ${e.source} | ${e.type} | ${e.message}');
    return false;
  } catch (e) {
    _error = OnError(
      type: 'provider',
      message: e.toString(),
      source: 'update',
    );

    debugPrint('ERROR PROVIDER update: $e');
    return false;
  } finally {
    _cargandoData = false;
    notifyListeners();
  }
}

Future<bool> reinciarLocal() async {
    final db = await dbLocal.instancia;
    try {
      final ok = await deleteFloraLocal(db, null);
      return ok;
    } catch (e) {
      return false;
    }
}

Future<bool> eliminar(String nombreCientifico) async {
  _error = null;
  notifyListeners();

  try {
    final destino = await _elegirBD();

    if (destino == 'remoto') {
      await softDeleteFloraRemoto(nombreCientifico);
    } else {
      final db = await dbLocal.instancia;
      final ok = await softDeleteLocal(db, nombreCientifico);

      if (!ok) {
        throw OnError(
          type: 'local',
          message: 'Error eliminando local',
          source: 'eliminar',
        );
      }
    }

    _especies.removeWhere(
      (e) => e.nombreCientifico == nombreCientifico,
    );
    _error = null;
    return true;
  } on OnError catch (e) {
    _error = e;
    debugPrint('ERROR PROVIDER eliminar: ${e.source} | ${e.type} | ${e.message}');
    return false;
  } catch (e) {
    _error = OnError(
      type: 'provider',
      message: e.toString(),
      source: 'eliminar',
    );

    debugPrint('ERROR PROVIDER eliminar: $e');
    return false;
  } finally {
    notifyListeners();
  }
}

Future<void> _insertarRemoto(
  Especie nueva,
  List<Uint8List> bytesList,
) async {
  final List<ImagenTemp> editado = [];

  try {
    for (final bytes in bytesList) {
      final url = await insertImagen(bytes, nueva.nombreCientifico);

      editado.add(
        ImagenTemp(
          urlFoto: url,
          estado: 'comprobado',
        ),
      );
    }

    final especieConImagenes = nueva.copyWith(imagenes: editado);

    await insertAPI(
      especieConImagenes.toJson(),
      'insertflora',
    );

    _especies.add(especieConImagenes);
  } on OnError {
    for (final img in editado) {
      if (img.urlFoto.isNotEmpty) {
        await deleteImagen(img.urlFoto);
      }
    }

    rethrow;
  } catch (e) {
    for (final img in editado) {
      if (img.urlFoto.isNotEmpty) {
        await deleteImagen(img.urlFoto);
      }
    }

    throw OnError(
      type: 'provider',
      message: e.toString(),
      source: '_insertarRemoto',
    );
  }
}

  Future<void> _insertarLocal(Especie nueva) async {
    final db = await dbLocal.instancia;
    final ok = await insertFloraLocal(db, [nueva]);
    if (ok) await cargarFlora();
  }

  Future<void> _updateRemoto(
    Especie nueva,
    List<Uint8List> bytesList,
  ) async {
    final editado = <ImagenTemp>[];
      for (final bytes in bytesList) {
        final url = await insertImagen(bytes, nueva.nombreCientifico);

        if (url.isEmpty) {
          throw OnError(
            type: 'image',
            message: 'Error subiendo la imagen',
            source: '_updateRemoto',
          );
        }
        editado.add(ImagenTemp(urlFoto: url, estado: 'comprobado'));
      }

      final imagenesValidas =
          nueva.imagenes.where((i) {
            return i.urlFoto.trim().isNotEmpty;
          }).toList();

      final especieConUrls = nueva.copyWith(
        imagenes: [...imagenesValidas, ...editado],
      );

      await updateFloraRemoto(especieConUrls.toJson());

      final index = _especies.indexWhere(
        (e) => e.nombreCientifico == nueva.nombreCientifico,
      );

      if (index != -1) {
        _especies[index] = especieConUrls;
      }
      notifyListeners();
  }

  Future<bool> _updateLocal(Especie nueva) async {
    final db = await dbLocal.instancia;
    final ok = await updateFloraLocal(db, nueva);
    if (ok) {
      final index = _especies.indexWhere(
        (e) => e.nombreCientifico == nueva.nombreCientifico,
      );
      if (index != -1) _especies[index] = nueva;
    }
    notifyListeners();
    return ok;
  }

  static bool tieneValor(String? valor) {
    return valor != null && valor.trim().isNotEmpty;
  }

  static bool esUno(int? v) => v == 1;

  final Map<String, bool Function(Especie)> _mapaFiltros = {
    'daSombra': (e) => esUno(e.daSombra),
    'Flor distintiva': (e) => tieneValor(e.florDistintiva),
    'Fruta distintiva': (e) => tieneValor(e.frutaDistintiva),
    'Pionero': (e) => esUno(e.pionero),
    'Salud del suelo': (e) => esUno(e.saludSuelo),
    'Crecimiento rápido': (e) => tieneValor(e.formaCrecimiento),
    'Crecimiento lento': (e) => tieneValor(e.formaCrecimiento),
    'Ambiente seco': (e) => tieneValor(e.ambiente),
    'Ambiente húmedo': (e) => tieneValor(e.ambiente),
    'Ambiente mixto': (e) => tieneValor(e.ambiente),
    'establecido al Sol': (e) => tieneValor(e.establecidoSolSombra),
    'establecido a Sombra': (e) => tieneValor(e.establecidoSolSombra),
    'establecido a ambos': (e) => tieneValor(e.establecidoSolSombra),
    'Hospeda monos':
        (e) => e.huespedes?.toLowerCase().contains('mono') ?? false,
    'Hospeda aves': (e) => e.huespedes?.toLowerCase().contains('ave') ?? false,
    'Polinizador abeja':
        (e) => e.polinizador?.toLowerCase().contains('abeja') ?? false,
    'Polinizador mariposa':
        (e) => e.polinizador?.toLowerCase().contains('mariposa') ?? false,
    'Polinizador mixto':
        (e) => e.polinizador?.toLowerCase().contains('mixto') ?? false,
    'Nativa América': (e) => esUno(e.nativoAmerica),
    'Nativa Panamá': (e) => esUno(e.nativoPanama),
    'Nativa Azuero': (e) => esUno(e.nativoAzuero),
    'Frutal':
        (e) => e.utilidades.any((u) => u.utilidad.toLowerCase() == 'frutal'),

    'Maderal':
        (e) => e.utilidades.any((u) => u.utilidad.toLowerCase() == 'maderal'),

    'Ganado':
        (e) => e.utilidades.any((u) => u.utilidad.toLowerCase() == 'ganado'),

    'Medicinal':
        (e) => e.utilidades.any((u) => u.utilidad.toLowerCase() == 'medicinal'),
  };

  List<Especie> get especiesFiltradas {
    if (_filtrosActivos.isEmpty) return _especies;

    return _especies.where((e) {
      for (final filtro in _filtrosActivos) {
        final evaluador = _mapaFiltros[filtro];

        if (evaluador != null && !evaluador(e)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void setFiltros(Set<String> nuevos) {
    _filtrosActivos
      ..clear()
      ..addAll(nuevos);
    notifyListeners();
  }

  Future<void> sincronizarManual() async {
    if (sincronizando) return;

    sincronizando = true;
    notifyListeners();

    final sinc = ControlSincronizacion();

    try {
      await sinc.sincronizar();
    } catch (e) {
      debugPrint('Error en sincronizarManual: $e');
    } finally {
      sincronizando = false;
      notifyListeners();
    }
  }
}
