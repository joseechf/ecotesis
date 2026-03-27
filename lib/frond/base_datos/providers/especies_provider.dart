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

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool _insertando = false;
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

  //  manejo de mensajes -------

  String? _ultimoMensaje;
  bool _ultimoError = false;

  String? get ultimoMensaje => _ultimoMensaje;
  bool get ultimoError => _ultimoError;

  void _setMensaje(String mensaje, {bool esError = false}) {
    _ultimoMensaje = mensaje;
    _ultimoError = esError;
    notifyListeners();
  }

  void limpiarMensaje() {
    _ultimoMensaje = null;
    _ultimoError = false;
  }

  // fin manejo de mensajes -------------

  Future<void> cargarFlora() async {
    final destino = await _elegirBD();
    _cargandoData = true;
    notifyListeners();

    try {
      _especies.clear();

      if (destino == 'remoto') {
        final response = await getFloraRemoto().timeout(
          const Duration(seconds: 20),
        );

        _especies.addAll(
          response.map<Especie>((json) => Especie.fromJson(json)).toList(),
        );
      } else {
        final db = await dbLocal.instancia;
        final especies = await cargarFloraLocal(db);
        _especies.addAll(especies);
      }
    } catch (e) {
      debugPrint('error al cargar: $e');
    } finally {
      _cargandoData = false;
      notifyListeners();
    }
  }

  Future<bool> insertar(Especie nueva, {List<Uint8List>? imgsBytes}) async {
    if (_insertando) return false;

    _insertando = true;

    try {
      final destino = await _elegirBD();
      // si el registro ya existe pero está soft delete se revive
      if (destino == 'remoto') {
        final resp =
            (imgsBytes != null)
                ? await _insertarRemoto(nueva, imgsBytes)
                : await insertFloraRemoto(nueva.toJson());
        if (!resp.ok) {
          final updateResp =
              (imgsBytes != null)
                  ? await _updateRemoto(nueva, imgsBytes)
                  : await updateFloraRemoto(nueva.toJson());
          if (!updateResp.ok) {
            _setMensaje(updateResp.message, esError: true);
            return false;
          }
          _setMensaje(updateResp.message);
          return true;
        }
        _setMensaje(resp.message);
        return true;
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
        _setMensaje("Insertado localmente");
      }

      await cargarFlora();
      return true;
    } catch (e) {
      _setMensaje("Error inesperado: $e", esError: true);
      return false;
    } finally {
      _insertando = false;
    }
  }

  Future<bool> update(Especie nueva, {List<Uint8List>? imgsBytes}) async {
    final destino = await _elegirBD();

    if (destino == 'remoto') {
      final resp = await _updateRemoto(nueva, imgsBytes ?? []);

      if (!resp.ok) {
        _setMensaje(resp.message, esError: true);
        return false;
      }

      _setMensaje(resp.message);
      return true;
    } else {
      final ok = await _updateLocal(nueva);
      _setMensaje(
        ok ? "Actualizado localmente" : "Error actualizando local",
        esError: !ok,
      );
      return ok;
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

  Future<void> eliminar(String nombreCientifico) async {
    final destino = await _elegirBD();

    if (destino == 'remoto') {
      final resp = await softDeleteFloraRemoto(nombreCientifico);

      if (!resp.ok) {
        _setMensaje(resp.message, esError: true);
        return;
      }

      _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);

      _setMensaje(resp.message);
    } else {
      final db = await dbLocal.instancia;
      //final ok = await deleteFloraLocal(db, nombreCientifico);
      final ok = await softDeleteLocal(db, nombreCientifico);

      if (!ok) {
        _setMensaje("Error eliminando local", esError: true);
        return;
      }

      _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);

      _setMensaje("Eliminado localmente");
    }

    notifyListeners();
  }

  Future<ApiResponse<void>> _insertarRemoto(
    Especie nueva,
    List<Uint8List> bytesList,
  ) async {
    final List<ImagenTemp> editado = [];

    try {
      for (final bytes in bytesList) {
        final url = await insertImagen(bytes, nueva.nombreCientifico);

        if (url.isEmpty) {
          throw Exception('Upload fallido: URL vacía');
        }

        editado.add(ImagenTemp(urlFoto: url, estado: 'comprobado'));
      }

      final especieConImagenes = nueva.copyWith(imagenes: editado);

      final resp = await insertFloraRemoto(especieConImagenes.toJson());

      if (!resp.ok) {
        throw Exception(resp.message);
      }

      _especies.add(especieConImagenes);

      return resp;
    } catch (e) {
      for (final img in editado) {
        if (img.urlFoto.isNotEmpty) {
          await deleteImagen(img.urlFoto);
        }
      }

      return ApiResponse(ok: false, message: e.toString());
    }
  }

  Future<void> _insertarLocal(Especie nueva) async {
    final db = await dbLocal.instancia;
    final ok = await insertFloraLocal(db, [nueva]);
    if (ok) await cargarFlora();
  }

  Future<ApiResponse<void>> _updateRemoto(
    Especie nueva,
    List<Uint8List> bytesList,
  ) async {
    final editado = <ImagenTemp>[];

    try {
      for (final bytes in bytesList) {
        final url = await insertImagen(bytes, nueva.nombreCientifico);

        if (url.isEmpty) {
          throw Exception('Upload fallido');
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

      final resp = await updateFloraRemoto(especieConUrls.toJson());

      if (!resp.ok) {
        throw Exception(resp.message);
      }

      final index = _especies.indexWhere(
        (e) => e.nombreCientifico == nueva.nombreCientifico,
      );

      if (index != -1) {
        _especies[index] = especieConUrls;
      }

      return resp;
    } catch (e) {
      for (final img in editado) {
        if (img.urlFoto.isNotEmpty) {
          await deleteImagen(img.urlFoto);
        }
      }

      return ApiResponse(ok: false, message: e.toString());
    }
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
    'Da sombra': (e) => esUno(e.daSombra),
    'Flor distintiva': (e) => tieneValor(e.florDistintiva),
    'Fruta distintiva': (e) => tieneValor(e.frutaDistintiva),
    'Pionero': (e) => esUno(e.pionero),
    'Salud del suelo': (e) => esUno(e.saludSuelo),
    'Crecimiento rápido': (e) => tieneValor(e.formaCrecimiento),
    'Crecimiento lento': (e) => tieneValor(e.formaCrecimiento),
    'Ambiente seco': (e) => tieneValor(e.ambiente),
    'Ambiente húmedo': (e) => tieneValor(e.ambiente),
    'Ambiente mixto': (e) => tieneValor(e.ambiente),
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
