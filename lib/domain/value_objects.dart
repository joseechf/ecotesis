/*import 'dart:typed_data';

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
*/
import 'dart:typed_data';

/// ---------------- NombreComun ----------------
class NombreComun {
  String nombreComun;

  NombreComun({required String nombreComun}) : nombreComun = nombreComun.trim();

  /// SQLite → VO
  factory NombreComun.fromRow(Map<String, dynamic> r) =>
      NombreComun(nombreComun: r['nombre_comun']);

  /// VO → SQLite
  Map<String, dynamic> toRow(String nombreCientifico) => {
    'nombre_comun': nombreComun,
    'nombre_cientifico': nombreCientifico,
  };
}

/// ---------------- Utilidad ----------------
class Utilidad {
  String utilidad;

  Utilidad({required String utilidad}) : utilidad = utilidad.trim();

  factory Utilidad.fromRow(Map<String, dynamic> r) =>
      Utilidad(utilidad: r['utilidad']);

  Map<String, dynamic> toRow(String nombreCientifico) => {
    'utilidad': utilidad,
    'nombre_cientifico': nombreCientifico,
  };
}

/// ---------------- Origen ----------------
class Origen {
  String origen;

  Origen({required String origen}) : origen = origen.trim();

  factory Origen.fromRow(Map<String, dynamic> r) => Origen(origen: r['origen']);

  Map<String, dynamic> toRow(String nombreCientifico) => {
    'origen': origen,
    'nombre_cientifico': nombreCientifico,
  };
}

/// ---------------- ImagenTemp ----------------
class ImagenTemp {
  String urlFoto; // url ya existente (opcional)
  String estado; // etiqueta local
  Uint8List? bytes; // bytes seleccionados (opcional)

  ImagenTemp({this.urlFoto = '', this.estado = 'tentativo', this.bytes});
}
