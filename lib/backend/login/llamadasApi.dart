import '../../frond/usuarios/usuarioPrueba.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:universal_html/html.dart' as html;
import 'elegirUrldeArranque.dart';

usuarioLogueado usuarioActual = usuarioLogueado();

Future<bool> registro() async {
  try {
    final response = await html.HttpRequest.request(
      '$baseUrl/registrar',
      method: 'POST',
      withCredentials: true, // 🔥 GUARDA LA COOKIE
      requestHeaders: {'Content-Type': 'application/json'},
      sendData: jsonEncode({
        'nombre': usuarioActual.getNombre(),
        'correo': usuarioActual.getCorreo(),
        'password': usuarioActual.getContrasena(),
        'rol': usuarioActual.getRol(),
      }),
    );
    final resultado = jsonDecode(response.responseText!);
    if (!resultado['ok']) {
      print('llamada registro mal');
      return false;
    } else {
      print('llamada registro bien');
    }
    final data = resultado['respuesta']['fila'];
    usuarioActual.setIdUsuario(data['idusuario']);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> login() async {
  try {
    final response = await html.HttpRequest.request(
      '$baseUrl/login',
      method: 'POST',
      withCredentials: true,
      requestHeaders: {'Content-Type': 'application/json'},
      sendData: jsonEncode({'idUsuario': usuarioActual.getIdUsuario()}),
    );
    final resultado = jsonDecode(response.responseText!);
    if (!resultado['ok']) {
      print('llamada login mal');
      return false;
    } else {
      print('llamada login bien');
    }
    final data = resultado['respuesta'];
    usuarioActual.setNombre(data['nombre']);
    usuarioActual.setCorreo(data['correo']);
    usuarioActual.setContrasena(data['password']);
    usuarioActual.setRol(data['rol']);
    return true;
  } catch (e) {
    print(e);
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
