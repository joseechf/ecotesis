import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utilidades/elegirUrldeArranque.dart';
import 'llamadasAPI.dart';
import '../../frond/admin/model/models.dart';

Future<Map<String, dynamic>> getRSiembra() async {
  try {
    final resp = await getData('getRegSiembra');
    return resp;
  } catch (e) {
    return {'ok': false, 'Error': e};
  }
}

Future<bool> insertReg(RSiembra nuevo) async {
  try {
    final resp = await llamarInsert(nuevo, 'insertRegSiembra');
    return resp;
  } catch (e) {
    print('$e');
    return false;
  }
}

Future<bool> llamarInsert(RSiembra modelo, String metodo) async {
  final url = Uri.parse('$baseUrl/$metodo');
  try {
    final Payload = {'fila': modelo.toJson()};
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(Payload),
        )
        .timeout(const Duration(seconds: 10));

    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      print('insercion $metodo mal');
      return false;
    } else {
      print('datos: $resp');
      print('insercion $metodo bien');
    }

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
