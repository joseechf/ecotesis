//para documentacion: el usuario no lo voy a modificar, se reemplaza

class UsuarioModel {
  final String id;
  final String email;
  final String rolActual;
  final String estadoRol;

  const UsuarioModel({
    required this.id,
    required this.email,
    required this.rolActual,
    required this.estadoRol,
  });

  factory UsuarioModel.fromProfile(Map<String, dynamic> data) {
    return UsuarioModel(
      id: data['id'] as String,
      email: data['email'] as String,
      rolActual: data['rol_actual'] as String,
      estadoRol: data['estado_rol'] as String,
    );
  }
}
