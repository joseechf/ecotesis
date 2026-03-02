import 'dart:convert';
import 'package:crypto/crypto.dart';

/*String calcularHash(Map<String, Object?> fila) {
  final clavesOrdenadas = fila.keys.toList()..sort();

  final Map<String, Object?> columnasFormateadas = {
    for (final clave in clavesOrdenadas) clave: fila[clave] ?? '',
  };

  final texto = jsonEncode(columnasFormateadas);
  return sha256.convert(utf8.encode(texto)).toString();
}*/

String calcularHash(Map<String, Object?> fila) {
  final copia = Map<String, Object?>.from(fila);

  copia.remove('Imagen');

  final clavesOrdenadas = copia.keys.toList()..sort();

  final Map<String, Object?> ordenado = {
    for (final clave in clavesOrdenadas) clave: copia[clave],
  };

  final texto = jsonEncode(ordenado);

  return sha256.convert(utf8.encode(texto)).toString();
}
