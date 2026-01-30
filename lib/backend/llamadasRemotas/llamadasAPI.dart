import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecoazuero/config/config.dart';

Future<Map<String, dynamic>> getData(String metodo) async {
  final url = Uri.parse('$baseUrl/$metodo');
  print(url);
  try {
    final response = await http.get(url);
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('llamada GET a $metodo mal');
      return resp;
    } else {
      print('llamada GET a $metodo bien');
      print('datos: $resp');
    }

    return resp;
  } catch (e) {
    print(e);
    return {'ok': false, 'Error': e};
  }
}
