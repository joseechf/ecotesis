class Especie {
  final String nombreLatino;
  final String nombre;
  final String imagen;
  final String establecido;
  final String ubicacion;
  final String polinizador;

  Especie({
    required this.nombreLatino,
    required this.nombre,
    required this.imagen,
    required this.establecido, //sol,sombra,mixto
    required this.ubicacion, //pionero
    required this.polinizador,
  });
}
