import '../../frond/usuarios/usuarioPrueba.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';

// SOLO se usa en WEB
import 'package:universal_html/html.dart' as html;
import './seguridad/token_storage.dart';

import 'package:ecoazuero/config/config.dart';

usuarioLogueado usuarioActual = usuarioLogueado();

/// ==========================
/// REGISTRO
/// ==========================
Future<bool> registro() async {
  try {
    // 🌐 WEB → cookies
    if (kIsWeb) {
      final response = await html.HttpRequest.request(
        '$baseUrl/registrar',
        method: 'POST',
        withCredentials: true,
        requestHeaders: {'Content-Type': 'application/json'},
        sendData: jsonEncode({
          'nombre': usuarioActual.getNombre(),
          'correo': usuarioActual.getCorreo(),
          'password': usuarioActual.getContrasena(),
          'rol': usuarioActual.getRol(),
        }),
      );

      final resultado = jsonDecode(response.responseText!);
      if (!resultado['ok']) return false;

      final data = resultado['respuesta']['fila'];
      usuarioActual.setIdUsuario(data['idusuario']);
      return true;
    }

    // 📱 MÓVIL → tokens
    final response = await http.post(
      Uri.parse('$baseUrl/registrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': usuarioActual.getNombre(),
        'correo': usuarioActual.getCorreo(),
        'password': usuarioActual.getContrasena(),
        'rol': usuarioActual.getRol(),
      }),
    );

    final resultado = jsonDecode(response.body);
    if (!resultado['ok']) return false;

    final data = resultado['respuesta']['fila'];
    usuarioActual.setIdUsuario(data['idusuario']);
    return true;
  } catch (e) {
    print('ERROR REGISTRO: $e');
    return false;
  }
}

/// ==========================
/// LOGIN
/// ==========================
Future<bool> login() async {
  debugPrint('>>> BASE_URL ACTUAL = $baseUrl');
  try {
    // 🌐 WEB → cookies HttpOnly
    if (kIsWeb) {
      final response = await html.HttpRequest.request(
        '$baseUrl/login',
        method: 'POST',
        withCredentials: true,
        requestHeaders: {'Content-Type': 'application/json'},
        sendData: jsonEncode({'idUsuario': usuarioActual.getIdUsuario()}),
      );

      final resultado = jsonDecode(response.responseText!);
      if (!resultado['ok']) return false;

      final data = resultado['respuesta'];
      usuarioActual.setNombre(data['nombre']);
      usuarioActual.setCorreo(data['correo']);
      usuarioActual.setRol(data['rol']);

      return true;
    }

    // 📱 MÓVIL → JWT en body
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idUsuario': usuarioActual.getIdUsuario()}),
    );

    final resultado = jsonDecode(response.body);
    if (!resultado['ok']) return false;

    // 🔐 guardar tokens (aquí o en un servicio)
    tokenStorage.saveAccessToken(resultado['accessToken']);
    tokenStorage.saveRefreshToken(resultado['refreshToken']);

    final usuario = resultado['usuario'];
    usuarioActual.setNombre(usuario['nombre']);
    usuarioActual.setCorreo(usuario['correo']);
    usuarioActual.setRol(usuario['rol']);

    return true;
  } catch (e) {
    print('ERROR LOGIN: $e');
    return false;
  }
}

/*
Future<bool> delete() async {
  final url = Uri.parse('$baseUrl/deleteUser/${usuarioActual.getIdUsuario()}');
  //final url = Uri.parse('$baseUrl/delete/a62890ce-5a70-46a2-99cf-c57775c37123');
  try {
    final response = await http.delete(url);
    print(response);
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}*/
Future<bool> delete() async {
  try {
    final response = await html.HttpRequest.request(
      '$baseUrl/deleteUser/${usuarioActual.getIdUsuario()}',
      method: 'DELETE',
      withCredentials: true,
    );

    final resultado = jsonDecode(response.responseText!);
    return resultado['ok'] == true;
  } catch (e) {
    print(e);
    return false;
  }
}

/*
Future<bool> update() async {
  try {
    return resultado['ok'] == true;
  } catch (e) {
    print(e);
    return false;
  }
}*/
