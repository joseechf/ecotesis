import 'dart:io';

Future<bool> validarRed() async {
  try {
    // Intentamos buscar el host de Google
    final resultado = await InternetAddress.lookup('google.com');

    // Si la lista no está vacía y tiene una dirección válida, hay internet
    if (resultado.isNotEmpty && resultado[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    // Si falla la búsqueda (DNS), no hay internet
    return false;
  }
}
