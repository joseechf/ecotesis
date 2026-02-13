import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:ecoazuero/config/config.dart';

import '../../../data/models/especie_dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import '../../core/supabaseClient.dart';

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

Future<bool> insertFloraRemoto(EspecieDto dto) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;
  if (session == null) {
    return false; // no autenticado
  }
  final url = Uri.parse('$baseUrl/insertflora');
  try {
    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode({
            'filas': [dto.toJson()],
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return false;
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
      return false;
    }
    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    debugPrint('insertFloraRemoto: $e');
    return false;
  }
}

Future<bool> updateFloraRemoto(EspecieDto dto) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;
  if (session == null) {
    return false; // no autenticado
  }
  final url = Uri.parse('$baseUrl/update/${dto.nombreCientifico}');
  try {
    final response = await http
        .patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          //body: jsonEncode({'fila': dto.toJson()}),
          body: jsonEncode({
            'filas': [dto.toJson()],
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return false;
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
      return false;
    }
    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    debugPrint('updateFlora: $e');
    return false;
  }
}

Future<bool> deleteFloraRemoto(String nombreCientifico) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    return false; // no autenticado
  }
  print('token: ${session.accessToken}');

  final url = Uri.parse('$baseUrl/delete/$nombreCientifico');

  try {
    final response = await http
        .delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return false;
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
      return false;
    }

    return jsonDecode(response.body)['ok'] == true;
  } catch (e) {
    debugPrint('deleteFlora: $e');
    return false;
  }
}

Future<String> insertImagen(Uint8List bytes, String nombreCientifico) async {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Imagen no válida');

  final jpgBytes = img.encodeJpg(decoded, quality: 90);

  if (nombreCientifico.trim().isEmpty) {
    throw Exception('Nombre científico vacío');
  }

  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    throw Exception('Usuario no autenticado');
  }

  final url = Uri.parse('$baseUrl/insertImagen');

  try {
    final request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${session.accessToken}';

    request.fields['nombreCientifico'] = nombreCientifico;

    request.files.add(
      http.MultipartFile.fromBytes(
        'imagen',
        jpgBytes,
        filename: '$nombreCientifico.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      throw Exception('No autenticado');
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
      throw Exception('Sin permisos');
    }

    final resp = jsonDecode(body);
    return resp['ok'] == true ? (resp['url'] ?? '') : '';
  } catch (e) {
    debugPrint('insertImagen: $e');
    return '';
  }
}

Future<void> deleteImagen(String urlImagen) async {
  if (urlImagen.isEmpty) return;

  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    debugPrint('Usuario no autenticado');
    return;
  }

  try {
    final response = await http
        .delete(
          Uri.parse('$baseUrl/deleteImagen'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode({'url': urlImagen}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
    }

    final body = jsonDecode(response.body);

    if (response.statusCode != 200 || body['ok'] != true) {
      debugPrint('No se pudo borrar la imagen $urlImagen');
    }
  } catch (e) {
    debugPrint('deleteImagen: $e');
  }
}
