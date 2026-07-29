import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:ecoazuero/config/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import '../../core/supabase_client.dart';
import '../../frond/iureutilizables/errores.dart';

Future<Map<String,dynamic>> getReporte() async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null){
    debugPrint('No autenticado');
    return {'status': 500};
  }

  final url = Uri.parse('$baseUrl/getReporte');

  try {
    final resp = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    },).timeout(const Duration(seconds: 10));

    if(resp.statusCode != 200) {
      return {'status': 500};
    }
    final reporte = jsonDecode(resp.body);

    return (reporte['status'] != 200) ? {'status': 200, 'reporte': reporte['reporte']} : {'status': 500};
  } catch (e) {
    debugPrint('$e');
    return {'status': 500};    
  }
}

Future<List<Map<String, dynamic>>> getFlora({
  required String endpoint,
  String method = 'GET',
  bool requiereAuth = false,
  Map<String, dynamic>? body,
}) async {
  final headers = <String, String>{'Content-Type': 'application/json'};
  
  if( requiereAuth){
    final session = SupabaseClientSingleton.client.auth.currentSession;

    if(session == null) {
      throw OnError.fromJson({'status': 401, 'message': 'no autenticado','type': TypeError.authentication},'getFlora');
    }
    headers['Authorization'] = 'Bearer ${session.accessToken}';
  }

  final url = Uri.parse('$baseUrl/$endpoint');

  http.Response resp;

  if(method == 'POST') {
    resp = await http.post(url, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(const Duration(seconds: 10));
  } else {
    resp = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
  }

  final decoded = jsonDecode(resp.body);

  if(resp.statusCode != 200) {
    throw OnError.fromJson({'status': decoded.status,'message': decoded.message,'type': TypeError.database},'API');
  }

  return List<Map<String,dynamic>>.from(decoded['data']);
}

Future<void> insertAPI (
  Map<String,dynamic> data,
  String metodo,
  int? version
) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null){
    throw OnError(
      type: TypeError.authentication,
      message: 'Usuario no autenticado',
      source: 'insertAPI',
      status: '401',  
    );
  }

  final url = Uri.parse('$baseUrl/$metodo');

  try {
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    },
    body: jsonEncode({'fila': data,'version': version}),
    ).timeout(const Duration(seconds: 10));

    final Map<String, dynamic> body = jsonDecode(response.body);

    if(response.statusCode != 200 || body['ok'] != true){
      final tipo = (body['type']?.toString() == TypeError.validacion) ? TypeError.validacion : TypeError.database;
      throw OnError.fromJson({'status': body['status'],'message': body['message'],'type': tipo},'API');
    }

    return;
  } on OnError{
    rethrow;
  } catch (e) {
    if(e.toString() == "TypeError: null: type 'Null' is not a subtype of type 'String'"){
      throw OnError(status: '500', type: TypeError.interface,message: 'Nombre Cientifico debe existir en la base de datos',source: 'mostrar');
    }
    throw OnError(status: '500', type: TypeError.interface,message: e.toString(),source: 'insertAPI');
  }
}

Future<void> updateFloraRemoto(
  Map<String,dynamic> especie,
  int? version
) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null) {
    throw OnError(
      type: TypeError.authentication,
      message: 'Usuario no autenticado',
      source: 'updateFloraRemoto',
      status: '401',  
    );
  }

  final nombre = especie['nombre_cientifico'];

  if(nombre == null){
    throw OnError(
      type: TypeError.validacion,
      message: 'Nombre cientifico invalido',
      source: 'updateFloraRemoto',
      status: '400',
    );
  }
  final url = Uri.parse('$baseUrl/update/${Uri.encodeComponent(nombre)}');

  try {
    final response = await http.patch(
      url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonEncode({'fila': especie, 'version': version}),
    ).timeout(const Duration(seconds: 10));

    final Map<String, dynamic> body = jsonDecode(response.body);

    if(response.statusCode != 200 || body['ok'] != true){
      final tipo = (body['type']?.toString() == TypeError.validacion) ? TypeError.validacion : TypeError.database;
      throw OnError.fromJson({'status': body['status'],'message': body['message'],'type': tipo},'API');
    }
    return;
  } on OnError {
    rethrow;
  } catch (e) {
    throw OnError(status: '500', type: TypeError.interface,message: e.toString(),source: 'updateFloraRemoto');
  }
}

Future<void> softDeleteFloraRemoto(
  String nombreCientifico,
) async {
  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null) {
    throw OnError(
      type: 'auth',
      message: 'Usuario no autenticado',
      source: 'softDeleteFloraRemoto',
      status: '401',
    );
  }

  final url = Uri.parse(
    '$baseUrl/softdelete/$nombreCientifico',
  );

  try {
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session.accessToken}',
    }).timeout(const Duration(seconds: 10));

    final Map<String, dynamic> body = jsonDecode(response.body);

    if(body['ok'] != true){
      final tipo = (body['type']?.toString() == TypeError.validacion) ? TypeError.validacion : TypeError.database;
      throw OnError.fromJson({'status': body['status'],'message': body['message'],'type': tipo},'API');
    }
    return;
  } on OnError {
    rethrow;
  } catch (e) {
    throw OnError(status: '500', type: TypeError.interface,message: e.toString(),source: 'softDeleteFloraRemoto');
  }
}

Future<String> insertImagen(
  Uint8List bytes,
  String nombreCientifico,
) async {
  final decoded = img.decodeImage(bytes);

  if(decoded == null){
    throw OnError(
      status: '422',
      type: TypeError.validacion,
      message: 'Imagen no valida',
      source: 'insertImagen',
    );
  }

  final jpgBytes = img.encodeJpg(decoded, quality: 90);

  if(nombreCientifico.trim().isEmpty) {
    throw OnError(
      type: TypeError.validacion,
      message: 'Nombre cientifico vacio',
      source: 'insertImagen',
      status: '422',
    ); 
  }

  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null){
    throw OnError(
      type: TypeError.authentication,
      message: 'Usuario no autenticado',
      source: 'insertImagen',
      status: '401',
    ); 
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
    final resp = await response.stream.bytesToString();
    final body = jsonDecode(resp);

    if(body['ok'] != true) {
      final tipo = (body['type']?.toString() == TypeError.validacion) ? TypeError.validacion : TypeError.database;
      throw OnError.fromJson({'status': body['status'],'message': body['message'],'type': tipo},'API');
    }
    
    return body['data'];
  } on OnError {
    rethrow;
  } catch (e) {
    throw OnError(status: '500', type: TypeError.interface,message: e.toString(),source: 'insertImagen');
  }
}

Future<void> deleteImagen(String urlImagen) async {
  if(urlImagen.isEmpty) return;

  final session = SupabaseClientSingleton.client.auth.currentSession;

  if(session == null){
    throw OnError(
      type: TypeError.authentication,
      message: 'Usuario no autenticado',
      source: 'deleteImagen',
      status: '401',
    );
  }

  try {
    final uri = Uri.parse(urlImagen);
    final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';

    if(fileName.isEmpty) {
      throw OnError(
        type: TypeError.validacion,
        message: 'Nombre de archivo invalido',
        source: 'deleteImagen',
        status: '422'
      );
    }

    final response = await http.delete(Uri.parse('$baseUrl/deleteImagen'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonEncode({'fileName': fileName}),
    ).timeout(const Duration(seconds: 10));

    final Map<String,dynamic> body = jsonDecode(response.body);

    if(response.statusCode != 200 || body['ok'] != true) {
      throw OnError.fromJson(body, 'deleteImagen');
    }
  } on OnError {
    rethrow;
  } catch (e) {
    throw OnError(status: '500', type: TypeError.interface,message: e.toString(),source: 'deleteImagen');
  }
}