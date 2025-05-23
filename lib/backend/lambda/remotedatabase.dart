import 'dart:convert';
import 'package:ecoazuero/backend/utilidades/variableglobal.dart';
import 'package:http/http.dart' as http;
import '../utilidades/item.dart';

class RemoteService {
  // Reemplaza con tu URL de API Gateway
  static const String _insertUrl =
      'https://t3f65fc1ta.execute-api.us-east-1.amazonaws.com/insertarFauna';
  String get _leerUrl => 'https://t3f65fc1ta.execute-api.us-east-1.amazonaws.com/leerFauna?ultSinc=${Variableglobal().ultimaSinc}';

  static Future<String> insertItem(Item item, DateTime ultAct) async {
    try {
      final response = await http.post(
        Uri.parse(_insertUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': item.id, 'nombre': item.name, 'tipo': item.tipo, 'ultAct': ultAct}),
      );
      if(response.statusCode >= 200 && response.statusCode < 300){
        return "insercion correcta";
      }else{
        final Map<String, dynamic> respuestaError = jsonDecode(response.body);
        return respuestaError['message'];
      }
    } catch (e) {
      return 'ERROR: $e';
    }
  }

  Future<List<Map<String,dynamic>>> leerDatos() async {
    try {
      final response = await http.get(Uri.parse(_leerUrl));
      if(response.statusCode >= 200 && response.statusCode < 300){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.cast<Map<String, dynamic>>();
      }else{
        final Map<String, dynamic> respuestaError = jsonDecode(response.body);
        return [{'Error: ': respuestaError['message']}];
      }
    } catch (e) {
      return [{'Error': '$e'}];
    }
  }
}
