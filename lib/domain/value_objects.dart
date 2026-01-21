import 'dart:typed_data';

// domain/value_objects/nombre_comun.dart
class NombreComun {
  String nombreComun;
  NombreComun({required this.nombreComun});
}

// domain/value_objects/utilidad.dart
class Utilidad {
  String utilidad;
  Utilidad({required this.utilidad});
}

// domain/value_objects/origen.dart
class Origen {
  String origen;
  Origen({required this.origen});
}

class ImagenTemp {
  String urlFoto; // url ya existente (opcional)
  String estado; // etiqueta local
  Uint8List? bytes; // bytes seleccionados (opcional)

  ImagenTemp({this.urlFoto = '', this.estado = 'tentativo', this.bytes});
}
