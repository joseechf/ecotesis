import '../../../domain/entities/especie_unificada.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import '../../../backend/llamadas_remotas/llamadas_flora.dart';
import '../../../backend/llamadas_locales/llamadas_flora.dart';
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
        final especies = await cargarFloraLocal();
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

      if (destino == 'remoto') {
        final resp = await _insertarRemoto(nueva, imgsBytes ?? []);

        if (!resp.ok) {
          _setMensaje(resp.message, esError: true);
          return false;
        }

        _setMensaje(resp.message);
      } else {
        await _insertarLocal(nueva);
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
      final ok = await deleteFloraLocal(nombreCientifico);

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
    final ok = await insertFloraLocal([nueva]);
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

      final especieConUrls = nueva.copyWith(
        imagenes: [...nueva.imagenes, ...editado],
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
    final ok = await updateFloraLocal(nueva);
    if (ok) {
      final index = _especies.indexWhere(
        (e) => e.nombreCientifico == nueva.nombreCientifico,
      );
      if (index != -1) _especies[index] = nueva;
    }
    notifyListeners();
    return ok;
  }

  List<Especie> get especiesFiltradas {
    if (_filtrosActivos.isEmpty) return _especies;

    return _especies.where((e) {
      for (final filtro in _filtrosActivos) {
        switch (filtro) {
          case 'Flor distintiva':
            return e.florDistintiva != null && e.florDistintiva!.isNotEmpty;

          case 'Fruta distintiva':
            return e.frutaDistintiva != null && e.frutaDistintiva!.isNotEmpty;

          case 'Da sombra':
            return e.daSombra == 1;

          case 'Pionero':
            return e.pionero == 1;

          case 'Estrato alto':
            return e.estrato?.toLowerCase() == 'alto';

          case 'Estrato medio':
            return e.estrato?.toLowerCase() == 'medio';

          case 'Estrato bajo':
            return e.estrato?.toLowerCase() == 'bajo';

          case 'Mejora suelo':
            return e.saludSuelo == 1;

          case 'Ambiente seco':
            return e.ambiente?.toLowerCase() == 'seco';

          case 'Ambiente húmedo':
            return e.ambiente?.toLowerCase() == 'humedo';

          case 'Ambiente mixto':
            return e.ambiente?.toLowerCase() == 'mixto';

          case 'Crecimiento rápido':
            return e.formaCrecimiento?.toLowerCase() == 'rapido';

          case 'Crecimiento lento':
            return e.formaCrecimiento?.toLowerCase() == 'lento';

          case 'Hospeda monos':
            return e.huespedes == 'Mono';

          case 'Hospeda aves':
            return e.huespedes == 'Aves';

          case 'Polinizador abeja':
            return e.polinizador == 'Abeja';

          case 'Polinizador mariposa':
            return e.polinizador == 'Mariposa';

          case 'Polinizador mixto':
            return e.polinizador == 'Mixto';

          case 'Nativa América':
            return e.nativoAmerica == 1;

          case 'Nativa Panamá':
            return e.nativoPanama == 1;

          case 'Nativa Azuero':
            return e.nativoAzuero == 1;

          case 'Frutal':
            return e.utilidades.any(
              (u) => u.utilidad.toLowerCase() == 'frutal',
            );

          case 'Maderal':
            return e.utilidades.any(
              (u) => u.utilidad.toLowerCase() == 'maderal',
            );

          case 'Ganado':
            return e.utilidades.any(
              (u) => u.utilidad.toLowerCase() == 'ganado',
            );

          case 'Medicinal':
            return e.utilidades.any(
              (u) => u.utilidad.toLowerCase() == 'medicinal',
            );

          default:
            return true;
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
