import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

import '../utilidades/elegirUrldeArranque.dart';

import '../../frond/baseDatos/models/especie.dart';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

Future<Map<String, dynamic>> getFlora() async {
  final url = Uri.parse('$baseUrl/getflora');
  try {
    final response = await http.get(url);
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('llamada Flora mal');
      return resp;
    } else {
      print('llamada Flora bien');
      print('datos: $resp');
    }

    return resp;
  } catch (e) {
    print(e);
    return {'ok': false, 'Error': e};
  }
}

Future<bool> insertFloraRemoto(Especie especie) async {
  final url = Uri.parse('$baseUrl/insertflora');
  try {
    final Payload = {
      'filas': [especie.toJson()],
    };
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(Payload),
        )
        .timeout(const Duration(seconds: 10));
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('insercion Flora mal');
      return false;
    } else {
      print('datos: $resp');
      print('insercion Flora bien');
    }

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<String> insertImagen(Uint8List bytes, String nombreCientifico) async {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Imagen no válida');
  final jpgBytes = img.encodeJpg(decoded, quality: 90);

  final url = Uri.parse('$baseUrl/insertImagen');
  if (nombreCientifico.trim().isEmpty) {
    throw Exception('Nombre científico obligatorio');
  }

  try {
    final request = http.MultipartRequest('POST', url);
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
    final resp = jsonDecode(body);

    if (resp['ok'] != true) throw Exception('Error al subir imagen');

    print('la url: ${resp['url']}');
    return resp['url'];
  } catch (e) {
    print(e);
    return '';
  }
}

Future<void> deleteImagen(String url) async {
  if (url.isEmpty) return;
  try {
    final uri = Uri.parse('$baseUrl/deleteImagen');
    final resp = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );
    if (resp.statusCode != 200 || jsonDecode(resp.body)['ok'] != true) {
      print('No se pudo borrar la imagen $url');
    }
  } catch (e) {
    print('Error llamando a deleteImagen: $e');
  }
}

Future<bool> deleteFlora(String nombreCientifico) async {
  final url = Uri.parse('$baseUrl/delete/$nombreCientifico');
  try {
    final response = await http.delete(url);
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('llamada Flora mal');
      return resp;
    } else {
      print('llamada Flora bien');
      print('datos: $resp');
    }
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> updateFlora(Especie especie) async {
  final url = Uri.parse('$baseUrl/update/${especie.nombreCientifico}');
  final payload = {
    'filas': [especie.toJson()],
  };
  try {
    final response = await http
        .patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 10));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('update mal');
      return false;
    } else {
      print('update bien');
      print('datos: $resp');
      return true;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
