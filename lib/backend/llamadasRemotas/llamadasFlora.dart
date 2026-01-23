import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../utilidades/elegirUrldeArranque.dart';

import '../../../data/models/especie_dto.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

Future<List<EspecieDto>> getFloraRemoto() async {
  final url = Uri.parse('$baseUrl/getflora');
  try {
    final resp = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    final json = jsonDecode(resp.body);
    if (json['ok'] != true) {
      debugPrint('getFloraRemoto error');
      return [];
    }
    return (json['respuesta'] as List)
        .map((j) => EspecieDto.fromJson(j))
        .toList();
  } catch (e) {
    debugPrint('getFloraRemoto excepción: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFloraRemoteSincronizacion(
  String ultSinc,
) async {
  final url = Uri.parse('$baseUrl/getsincronizacion');

  try {
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ultSinc': ultSinc}),
    );

    final json = jsonDecode(resp.body);
    if (json['ok'] != true) return [];

    return List<Map<String, dynamic>>.from(json['respuesta']);
  } catch (e) {
    debugPrint('getFloraRemoteCambiosDesde error: $e');
    return [];
  }
}

Future<List<EspecieDto>> getFloraRemotoPorIds(List<String> ids) async {
  if (ids.isEmpty) return [];

  final url = Uri.parse('$baseUrl/getflora/porids');

  try {
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': ids}),
    );

    final json = jsonDecode(resp.body);
    if (json['ok'] != true) return [];

    return (json['respuesta'] as List)
        .map((e) => EspecieDto.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('getFloraRemotoPorIds error: $e');
    return [];
  }
}

/* =========================================================
   2.  ESCRITURA  →  recibe EspecieDto
   ========================================================= */
Future<bool> insertFloraRemoto(EspecieDto dto) async {
  final url = Uri.parse('$baseUrl/insertflora');
  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'filas': [dto.toJson()],
          }),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    print('insertFloraRemoto: $e');
    return false;
  }
}

Future<bool> updateFloraRemoto(EspecieDto dto) async {
  final url = Uri.parse('$baseUrl/update/${dto.nombreCientifico}');
  try {
    final response = await http
        .patch(
          url,
          headers: {'Content-Type': 'application/json'},
          //body: jsonEncode({'fila': dto.toJson()}),
          body: jsonEncode({
            'filas': [dto.toJson()],
          }),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    print('updateFlora: $e');
    return false;
  }
}

Future<bool> deleteFloraRemoto(String nombreCientifico) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$nombreCientifico'),
    );
    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    print('deleteFlora: $e');
    return false;
  }
}

/* =========================================================
   3.  IMÁGENES
   ========================================================= */
Future<String> insertImagen(Uint8List bytes, String nombreCientifico) async {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Imagen no válida');
  final jpgBytes = img.encodeJpg(decoded, quality: 90);

  final url = Uri.parse('$baseUrl/insertImagen');
  if (nombreCientifico.trim().isEmpty)
    throw Exception('Nombre científico vacío');

  try {
    final request =
        http.MultipartRequest('POST', url)
          ..fields['nombreCientifico'] = nombreCientifico
          ..files.add(
            http.MultipartFile.fromBytes(
              'imagen',
              jpgBytes,
              filename: '$nombreCientifico.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final resp = jsonDecode(body);
    return resp['ok'] == true ? (resp['url'] ?? '') : '';
  } catch (e) {
    print('insertImagen: $e');
    return '';
  }
}

Future<void> deleteImagen(String url) async {
  if (url.isEmpty) return;
  try {
    final resp = await http.delete(
      Uri.parse('$baseUrl/deleteImagen'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );
    if (resp.statusCode != 200 || jsonDecode(resp.body)['ok'] != true) {
      print('No se pudo borrar la imagen $url');
    }
  } catch (e) {
    print('deleteImagen: $e');
  }
}
