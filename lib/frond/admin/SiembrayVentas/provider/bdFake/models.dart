class Siembra {
  final String idSiembra;
  final String nombreLatino;
  final int cantDisponible;
  final String forma;
  Siembra({
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
  final String idRegistro;
  final String idSiembra;
  final String nombreLatino;
  final String idUsuario;
  final String nombreUsuario;
  final String fechaPlantacion;
  final String fechaBrote;
  final int cantidad;
  final String coordenadas;
  RSiembra({
    required this.idRegistro,
    required this.idSiembra,
    required this.nombreLatino,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.fechaPlantacion,
    required this.fechaBrote,
    required this.cantidad,
    required this.coordenadas,
  });
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
