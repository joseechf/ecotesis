import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecoazuero/config/config.dart';
import 'package:flutter/foundation.dart';
import '../../frond/admin/model/models.dart';

Future<Map<String, dynamic>> getRSiembra() async {
  final url = Uri.parse('$baseUrl/getRegSiembra');
  debugPrint('$url');
  try {
    final response = await http.get(url);
    final resp = jsonDecode(response.body);
    if (resp['ok'] != true) {
      debugPrint('llamada GET a getRegSiembra mal');
      return resp;
    } else {
      debugPrint('llamada GET a getRegSiembra bien');
      debugPrint('datos: $resp');
    }

    return resp;
  } catch (e) {
    debugPrint('$e');
    return {'ok': false, 'Error': e};
  }
}

Future<bool> insertReg(RSiembra nuevo) async {
  try {
    final resp = await llamarInsert(nuevo, 'insertRegSiembra');
    return resp;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

Future<bool> llamarInsert(RSiembra modelo, String metodo) async {
  final url = Uri.parse('$baseUrl/$metodo');
  debugPrint('>>> BASE_URL ACTUAL = $baseUrl');
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
      debugPrint('insercion $metodo mal');
      return false;
    } else {
      debugPrint('datos: $resp');
      debugPrint('insercion $metodo bien');
    }

    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}
