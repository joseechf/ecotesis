class UsuarioSolicitudModel {
  final String id;
  final String email;
  final String rolSolicitado;
  final String estadoRol;
  final DateTime createdAt;

  const UsuarioSolicitudModel({
    required this.id,
    required this.email,
    required this.rolSolicitado,
    required this.estadoRol,
    required this.createdAt,
  });

  factory UsuarioSolicitudModel.fromMap(Map<String, dynamic> data) {
    return UsuarioSolicitudModel(
      id: data['id'] as String,
      email: data['email'] as String,
      rolSolicitado: data['rol_solicitado'] as String,
      estadoRol: data['estado_rol'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
