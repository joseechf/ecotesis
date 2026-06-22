import 'dart:typed_data';

//NombreComun
class NombreComun {
  String nombre_comun;
  NombreComun({required this.nombre_comun});


  // SQLITE a VO
  factory NombreComun.fromMap(Map<String, dynamic> mapa){
    return NombreComun(nombre_comun: mapa['nombre_comun'] as String);
  }

  // VO a  SQLITE
  Map<String, dynamic> toMap(){
    return {
      'nombre_comun': nombre_comun,
    };
  }
}

// Utilidad
class Utilidad {
  String utilidad;

  Utilidad({required this.utilidad});
  factory Utilidad.fromMap(
    Map<String, dynamic> mapa,
  ){
    return Utilidad(utilidad: mapa['utilidad'] as String);
  }
  Map<String, dynamic> toMap(){
    return {
      'utilidad': utilidad,
    };
  }
}

// Origen
class Origen{
  String origen;
  Origen({required this.origen});

  factory Origen.fromMap(
    Map<String, dynamic> mapa,
  ){
    return Origen(origen: mapa['origen'] as String);
  }
  Map<String, dynamic> toMap(){
    return {
      'origen': origen,
    };
  }
}

// ImagenTemp
class ImagenTemp {
  String url_foto;
  String estado;
  Uint8List ? bytes;

  ImagenTemp({this.url_foto = '', this.estado = 'tentativo', this.bytes});

  factory ImagenTemp.fromMap(
    Map<String, dynamic> mapa,
  ){
    return ImagenTemp(url_foto: mapa['url_foto'] as String, estado: mapa['estado'] as String);
  }
  Map<String, dynamic> toMap(){
    return {
      'url_foto': url_foto,
      'estado': estado
    };
  }
}