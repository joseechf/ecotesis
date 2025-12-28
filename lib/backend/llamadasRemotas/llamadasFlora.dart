import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

import '../utilidades/elegirUrldeArranque.dart';

//import '../../frond/baseDatos/providers/especies_provider.dart';
import '../../frond/baseDatos/models/especie.dart';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

//EspeciesProvider especieActual = EspeciesProvider();

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

Future<bool> insertFlora(Especie especie) async {
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
  // 1. Fuerza JPG: convierte cualquier entrada a JPEG
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Imagen no válida');
  final jpgBytes = img.encodeJpg(decoded, quality: 90);

  // 2. Validaciones
  final url = Uri.parse('$baseUrl/insertImagen');
  if (nombreCientifico.trim().isEmpty) {
    throw Exception('Nombre científico obligatorio');
  }

  // 3. Petición siempre JPG
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

Future<bool> updateFlora(Map<String, dynamic> especie) async {
  final url = Uri.parse('$baseUrl/update/${especie['nombreCientifico']}');
  final Payload = [especie];
  try {
    final response = await http
        .put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(Payload),
        )
        .timeout(const Duration(seconds: 10));
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
