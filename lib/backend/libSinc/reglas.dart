/// Regla: si las versiones son iguales, siempre gana remoto
String resolucionVersionIgual(
  String id,
  Map<String, dynamic> item,
  Map<String, dynamic> mapaLocal, // ← String key
) {
  if (item['version'] == mapaLocal[id]?['version']) {
    return 'remoto';
  }
  return 'remoto';
}
