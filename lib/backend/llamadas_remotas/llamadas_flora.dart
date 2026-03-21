import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:ecoazuero/config/config.dart';

import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import '../../core/supabase_client.dart';

Future<List<Map<String, dynamic>>> getFloraRemoto() async {
  final url = Uri.parse('$baseUrl/getflora');

  try {
    final resp = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      debugPrint('Error HTTP: ${resp.statusCode}');
      return [];
    }

    final json = jsonDecode(resp.body);

    return validarRespuesta(json);
  } catch (e) {
    debugPrint('getFloraRemoto excepción: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFloraRemoteSincronizacion({
  String? ultSinc,
}) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    debugPrint('No autenticado');
    return [];
  }

  final url = Uri.parse('$baseUrl/getsincronizacion');

  try {
    final body = <String, dynamic>{};

    if (ultSinc != null && ultSinc.isNotEmpty) {
      body['ultSinc'] = ultSinc;
    }

    final resp = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return [];
    }

    if (resp.statusCode == 403) {
      debugPrint('rol no autorizado');
      return [];
    }

    if (resp.statusCode != 200) {
      debugPrint('Error HTTP: ${resp.statusCode}');
      return [];
    }

    final json = jsonDecode(resp.body);

    return validarRespuesta(json);
  } catch (e) {
    debugPrint('getFloraRemoteSincronizacion error: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> obtenerFloraRemotaById(
  List<String> ids,
) async {
  if (ids.isEmpty) return [];

  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    debugPrint('No autenticado');
    return [];
  }

  final url = Uri.parse('$baseUrl/getflora/porids');

  try {
    final resp = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode({'ids': ids}),
        )
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return [];
    }

    if (resp.statusCode == 403) {
      debugPrint('rol no autorizado');
      return [];
    }

    if (resp.statusCode != 200) {
      debugPrint('Error HTTP: ${resp.statusCode}');
      return [];
    }

    final json = jsonDecode(resp.body);

    return validarRespuesta(json);
  } catch (e) {
    debugPrint('getFloraRemotoPorIds error: $e');
    return [];
  }
}

Future<ApiResponse<void>> insertFloraRemoto(
  Map<String, dynamic> especieJson,
) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    return ApiResponse(ok: false, message: "Usuario no autenticado");
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
            'filas': [especieJson],
          }),
        )
        .timeout(const Duration(seconds: 10));

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode == 401) {
      return ApiResponse(ok: false, message: "Sesión expirada");
    }

    if (response.statusCode == 403) {
      return ApiResponse(ok: false, message: "No tienes permisos");
    }

    if (body['ok'] != true) {
      return ApiResponse(
        ok: false,
        message: body['message'] ?? "Error del servidor",
      );
    }

    return ApiResponse(ok: true, message: "Insertado correctamente");
  } catch (e) {
    return ApiResponse(ok: false, message: "Error de conexión: $e");
  }
}

Future<ApiResponse<void>> updateFloraRemoto(
  Map<String, dynamic> especie,
) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;
  debugPrint('=================session token: $session');

  if (session == null) {
    return ApiResponse(ok: false, message: "Usuario no autenticado");
  }

  final nombre = especie['nombre_cientifico'];

  if (nombre == null) {
    return ApiResponse(ok: false, message: "Nombre científico inválido");
  }

  final url = Uri.parse('$baseUrl/update/${Uri.encodeComponent(nombre)}');

  try {
    final response = await http
        .patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode({
            'filas': [especie],
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 401) {
      return ApiResponse(ok: false, message: "Sesión expirada");
    }

    if (response.statusCode == 403) {
      return ApiResponse(ok: false, message: "No tienes permisos");
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['ok'] != true) {
      return ApiResponse(
        ok: false,
        message:
            body['message'] ?? body['error'] ?? "Error actualizando especie",
      );
    }

    return ApiResponse(
      ok: true,
      message: body['message'] ?? "Actualización completada",
    );
  } catch (e) {
    return ApiResponse(ok: false, message: "Error de conexión: $e");
  }
}

Future<ApiResponse<void>> softDeleteFloraRemoto(String nombreCientifico) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if (session == null) {
    return ApiResponse(ok: false, message: "Usuario no autenticado");
  }

  final url = Uri.parse('$baseUrl/softdelete/$nombreCientifico');

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
      return ApiResponse(ok: false, message: "Sesión expirada");
    }

    if (response.statusCode == 403) {
      return ApiResponse(ok: false, message: "No tienes permisos");
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['ok'] != true) {
      return ApiResponse(
        ok: false,
        message: body['message'] ?? "Error eliminando registro",
      );
    }

    return ApiResponse(
      ok: true,
      message: body['message'] ?? "Soft delete correcto",
    );
  } catch (e) {
    return ApiResponse(ok: false, message: "Error de conexión: $e");
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
  debugPrint('la url : $url');

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

    final json = jsonDecode(body);

    if (json['ok'] != true) {
      throw Exception(json['message'] ?? 'Error al subir imagen');
    }

    return json['data'] ?? '';
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
    final uri = Uri.parse(urlImagen);
    final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';

    if (fileName.isEmpty) {
      debugPrint('Nombre de archivo inválido: $urlImagen');
      return;
    }
    final response = await http
        .delete(
          Uri.parse('$baseUrl/deleteImagen'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
          },
          body: jsonEncode({'fileName': fileName}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 401) {
      debugPrint('token expirado o no autorizado');
      return;
    }

    if (response.statusCode == 403) {
      debugPrint('rol no autorizado');
      return;
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (json['ok'] != true) {
      debugPrint(
        'No se pudo borrar la imagen $urlImagen: ${json['message'] ?? 'error desconocido'}',
      );
    }
  } catch (e) {
    debugPrint('deleteImagen: $e');
  }
}

class ApiResponse<T> {
  final bool ok;
  final String message;
  final T? data;

  ApiResponse({required this.ok, required this.message, this.data});
}

List<Map<String, dynamic>> validarRespuesta(Map<String, dynamic> json) {
  if (json['ok'] != true) return [];
  return (json['data'] as List).cast<Map<String, dynamic>>();
}
