import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<bool> validarRed() async {
  try {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Accept' : 'application/json'},
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: (){
        debugPrint('TIEMPO LIMITE DE VERIFICACIÓN DE RED ALCANZADO ');
        throw Exception('Timeout');
      },
    );
    debugPrint('wifi ? ${response.statusCode == 200}');
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}