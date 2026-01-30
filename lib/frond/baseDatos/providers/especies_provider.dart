import 'package:flutter/material.dart';
import '../../../domain/entities/especie.dart';
import '../../../data/mappers/especie_mapper.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import '../../../backend/llamadasRemotas/llamadasFlora.dart';
import '../../../backend/llamadasLocales/llamadasFlora.dart';
import '../../../validarRed.dart';
import '../../../domain/value_objects.dart';
import '../../../backend/libSinc/sincronizacion.dart';

class EspeciesProvider with ChangeNotifier {
  final List<Especie> _especies = [];
  bool _cargandoData = false;
  bool _insertando = false;
  bool sincronizando = false;
  bool get cargandoData => _cargandoData;
  List<Especie> get especies => _especies;

  String _filtro = 'all';
  String get filtro => _filtro;

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
    notifyListeners();
    try {
      if (destino == 'remoto') {
        final dtos = await getFloraRemoto().timeout(
          const Duration(seconds: 20),
        );
        _especies.clear();
        _especies.addAll(
          dtos.map((dto) => EspecieMapper.fromDto(dto)).toList(),
        );
      } else {
        final especies = await cargarFloraLocal();
        _especies.clear();
        _especies.addAll(especies);
      }
    } catch (e) {
      debugPrint('[Provider] error al cargar: $e');
    } finally {
      _cargandoData = false;
      notifyListeners();
    }
  }

  Future<void> insertar(Especie nueva, {List<Uint8List>? imgsBytes}) async {
    if (_insertando) {
      debugPrint(' insertar bloqueado: ya en progreso');
      return;
    }

    _insertando = true;
    debugPrint(' insertar iniciado');

    try {
      final destino = await _elegirBD();
      if (destino == 'remoto') {
        await _insertarRemoto(nueva, imgsBytes ?? []);
      } else {
        await _insertarLocal(nueva);
      }
    } finally {
      _insertando = false;
      debugPrint('⏹ insertar finalizado');
    }
  }

  Future<bool> update(Especie nueva, {List<Uint8List>? imgsBytes}) async {
    final destino = await _elegirBD();
    return destino == 'remoto'
        ? await _updateRemoto(nueva, imgsBytes ?? [])
        : await _updateLocal(nueva);
  }

  Future<void> eliminar(String nombreCientifico) async {
    final destino = await _elegirBD();
    if (destino == 'remoto') {
      final ok = await deleteFloraRemoto(nombreCientifico);
      if (ok)
        _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);
    } else {
      final ok = await deleteFloraLocal(nombreCientifico);
      if (ok)
        _especies.removeWhere((e) => e.nombreCientifico == nombreCientifico);
    }
    notifyListeners();
  }

  /* ----------  privados ---------- */
  Future<void> _insertarRemoto(Especie nueva, List<Uint8List> bytesList) async {
    final List<ImagenTemp> uploaded = [];

    debugPrint('--- [_insertarRemoto] INICIO ---');
    debugPrint('Nombre científico: ${nueva.nombreCientifico}');
    debugPrint('Cantidad de imágenes (bytes): ${bytesList.length}');

    try {
      /* ---------- 1. Subir imágenes ---------- */
      for (int i = 0; i < bytesList.length; i++) {
        debugPrint('Subiendo imagen ${i + 1}/${bytesList.length}');

        final url = await insertImagen(bytesList[i], nueva.nombreCientifico);

        debugPrint('URL recibida: "$url"');

        if (url.isEmpty) {
          throw Exception('Upload fallido: URL vacía');
        }

        uploaded.add(ImagenTemp(urlFoto: url, estado: 'comprobado'));
      }

      debugPrint('Imágenes subidas correctamente: ${uploaded.length}');

      /* ---------- 2. Construir Especie SOLO con URLs ---------- */
      final especieConImagenes = Especie(
        nombreCientifico: nueva.nombreCientifico,
        daSombra: nueva.daSombra,
        florDistintiva: nueva.florDistintiva,
        frutaDistintiva: nueva.frutaDistintiva,
        saludSuelo: nueva.saludSuelo,
        huespedes: nueva.huespedes,
        formaCrecimiento: nueva.formaCrecimiento,
        pionero: nueva.pionero,
        polinizador: nueva.polinizador,
        ambiente: nueva.ambiente,
        nativoAmerica: nueva.nativoAmerica,
        nativoPanama: nueva.nativoPanama,
        nativoAzuero: nueva.nativoAzuero,
        estrato: nueva.estrato,
        nombresComunes: nueva.nombresComunes,
        utilidades: nueva.utilidades,
        origenes: nueva.origenes,

        imagenes: uploaded,
      );

      debugPrint('Especie construida, enviando a API...');
      debugPrint('Imágenes en DTO: ${uploaded.map((e) => e.urlFoto).toList()}');

      /* ---------- 3. Enviar a API ---------- */
      final dto = especieConImagenes.toDto();
      final ok = await insertFloraRemoto(dto);

      debugPrint('Respuesta insertFloraRemoto: $ok');

      if (!ok) {
        throw Exception('Insert remoto fallido');
      }

      /* ---------- 4. Actualizar memoria ---------- */
      _especies.add(especieConImagenes);

      debugPrint('--- [_insertarRemoto] FIN OK ---');
    } catch (e, s) {
      debugPrint(' Error en _insertarRemoto: $e');
      debugPrintStack(stackTrace: s);

      /* ---------- rollback imágenes ---------- */
      for (final img in uploaded) {
        if (img.urlFoto.isNotEmpty) {
          await deleteImagen(img.urlFoto);
          debugPrint('Rollback imagen: ${img.urlFoto}');
        }
      }

      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _insertarLocal(Especie nueva) async {
    final ok = await insertFloraLocal([nueva]);
    if (ok) await cargarFlora();
  }

  Future<bool> _updateRemoto(Especie nueva, List<Uint8List> bytesList) async {
    final uploaded = <ImagenTemp>[];

    try {
      // 1. Subir cada imagen
      for (final bytes in bytesList) {
        final url = await insertImagen(bytes, nueva.nombreCientifico);
        if (url.isEmpty) throw Exception('Upload fallido');

        uploaded.add(ImagenTemp(urlFoto: url, estado: 'comprobado'));
      }

      // 2. construir Especie con URLs completas
      final especieConUrls = Especie(
        nombreCientifico: nueva.nombreCientifico,
        daSombra: nueva.daSombra,
        florDistintiva: nueva.florDistintiva,
        frutaDistintiva: nueva.frutaDistintiva,
        saludSuelo: nueva.saludSuelo,
        huespedes: nueva.huespedes,
        formaCrecimiento: nueva.formaCrecimiento,
        pionero: nueva.pionero,
        polinizador: nueva.polinizador,
        ambiente: nueva.ambiente,
        nativoAmerica: nueva.nativoAmerica,
        nativoPanama: nueva.nativoPanama,
        nativoAzuero: nueva.nativoAzuero,
        estrato: nueva.estrato,
        nombresComunes: nueva.nombresComunes,
        utilidades: nueva.utilidades,
        origenes: nueva.origenes,
        imagenes: [...nueva.imagenes, ...uploaded],
      );

      // 3. convertir a DTO y enviar
      final dto = especieConUrls.toDto();
      final ok = await updateFloraRemoto(dto);
      if (!ok) throw Exception('Update remoto fallido');

      // 4. actualizar lista en memoria
      final index = _especies.indexWhere(
        (e) => e.nombreCientifico == nueva.nombreCientifico,
      );
      if (index != -1) _especies[index] = especieConUrls;
      return true;
    } catch (e) {
      for (final img in uploaded) {
        if (img.urlFoto.isNotEmpty) {
          await deleteImagen(img.urlFoto);
        }
      }
      return false;
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
    if (_filtro == 'all') return _especies;
    return _especies.where((e) {
      switch (_filtro) {
        case 'Flor distintiva':
          return e.florDistintiva != null;
        case 'Fruta distintiva':
          return e.frutaDistintiva != null;
        case 'Salud del suelo':
          return e.saludSuelo == 1;
        default:
          return true;
      }
    }).toList();
  }

  Future<void> sincronizarManual() async {
    if (sincronizando) return;

    sincronizando = true;
    notifyListeners();

    final sinc = ControlSincronizacion();

    try {
      debugPrint('iniciando la sincronizacion...');
      await sinc.sincronizar();
    } catch (e) {
      debugPrint('Error en sincronizarManual: $e');
    } finally {
      sincronizando = false;
      notifyListeners();
    }
  }

  void setFiltro(String valor) {
    _filtro = valor;
    notifyListeners();
  }
}
