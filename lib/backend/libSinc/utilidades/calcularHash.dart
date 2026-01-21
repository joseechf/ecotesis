import 'dart:convert';
import 'package:crypto/crypto.dart';

String calcularHash(Map<String, Object?> fila) {
  final clavesOrdenadas = fila.keys.toList()..sort();

  final Map<String, Object?> columnasFormateadas = {
    for (final clave in clavesOrdenadas) clave: fila[clave] ?? '',
  };

  final texto = jsonEncode(columnasFormateadas);
  return sha256.convert(utf8.encode(texto)).toString();
}
