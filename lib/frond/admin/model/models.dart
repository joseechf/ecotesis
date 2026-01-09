import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

class Sembrable {
  final String idSiembra;
  final String nombreLatino;
  final int cantDisponible;
  final String forma;
  Sembrable({
    required this.idSiembra,
    required this.nombreLatino,
    required this.cantDisponible,
    required this.forma,
  });
}

class Vendibles {
  final String idVendible;
  final String nombreLatino;
  final int cantDisponible;
  final String forma;
  Vendibles({
    required this.idVendible,
    required this.nombreLatino,
    required this.cantDisponible,
    required this.forma,
  });
}

class RSiembra {
  String? idRegistro;
  String? idUsuario;
  String? nombreUsuario;
  final DateTime fechaPlantacion;
  List<SembrableRegistro> relacion;

  RSiembra.crear({
    this.idUsuario,
    required this.fechaPlantacion,
    required List<SembrableRegistro>? relacion,
  }) : idRegistro = null,
       relacion = relacion ?? [];
  RSiembra.getBD({
    required this.idRegistro,
    this.idUsuario,
    this.nombreUsuario,
    required this.fechaPlantacion,
    List<SembrableRegistro>? relacion,
  }) : relacion = relacion ?? [];

  factory RSiembra.jsonToEspecie(Map<String, dynamic> fila) {
    final relacion =
        (fila['relacion'] as List).map((e) {
          return SembrableRegistro(
            nombreCientifico: e['nombreCientifico'] as String,
            cantidadSembrado: e['cantidad'] as int,
            coordenadas: LatLng(
              (e['coord']['lat'] as num).toDouble(),
              (e['coord']['lng'] as num).toDouble(),
            ),
            estado: e['estado'] as String,
          );
        }).toList();

    return RSiembra.getBD(
      idRegistro: fila['idregistrosembrado'],
      idUsuario: fila['idusuario_fk'],
      nombreUsuario: fila['nombre'],
      fechaPlantacion: DateTime.parse(fila['fechasembrado']).toLocal(),
      relacion: relacion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idUsuario != null) 'idUsuario': idUsuario,
      'fechaPlantacion': fechaPlantacion.toIso8601String(),
      'Sembrable_RegistroSembrado': relacion.map((e) => e.toJson()).toList(),
    };
  }
}

//esta clase es la conexion entre sembrable y registro de siembra
class SembrableRegistro {
  String nombreCientifico;
  int cantidadSembrado;
  LatLng? coordenadas;
  String estado;

  SembrableRegistro({
    required this.nombreCientifico,
    required this.cantidadSembrado,
    required this.coordenadas,
    required this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombreCientifico': nombreCientifico,
      'cantidadSembrado': cantidadSembrado,
      'lat': coordenadas?.latitude,
      'lng': coordenadas?.longitude,
      'estado': estado,
    };
  }

  factory SembrableRegistro.vacio() {
    return SembrableRegistro(
      nombreCientifico: '',
      cantidadSembrado: 0,
      coordenadas: null,
      estado: '',
    );
  }
}

class RVentas {
  final String idRegistro;
  final String idVendible;
  final String nombreLatino;
  final String idUsuario;
  final String nombreUsuario;
  final String fecha;
  final int cantidad;
  RVentas({
    required this.idRegistro,
    required this.idVendible,
    required this.nombreLatino,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.fecha,
    required this.cantidad,
  });
}

class terrenosAlquilados {
  final String idAlquiler;
  final String idUsuario;
  final String fechaInicio;
  final String fechaFinal;
  final String direccion;
  final String tamanio; //alto y ancho
  final String caracterizacion;
  final String estado;
  terrenosAlquilados({
    required this.idAlquiler,
    required this.idUsuario,
    required this.fechaInicio,
    required this.fechaFinal,
    required this.direccion,
    required this.tamanio, //alto y ancho
    required this.caracterizacion,
    required this.estado,
  });
}
