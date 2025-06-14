class Modeloplanta {
  final String id;
  final String nombre;
  final String tipo;
  final String cientifico;
  final String imagen;
  final String ultAct;
  final bool sincronizado;

  Modeloplanta({
    required this.id,
    required this.nombre,
    this.tipo = '',
    this.cientifico = '',
    this.imagen = '',
    required this.ultAct,
    this.sincronizado = false,
  });

  Map<String,dynamic>toMap(){
    return {
      'nombre': nombre,
      'tipo': tipo,
      'cientifico': cientifico,
      'imagen': imagen
    };
  }

}