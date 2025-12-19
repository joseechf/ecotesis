class usuarioLogueado {
  static final usuarioLogueado _instancia = usuarioLogueado._internal();

  usuarioLogueado._internal();

  factory usuarioLogueado() {
    return _instancia;
  }

  String _idUsuario = '';
  String _rolSeleccionado = 'No role';
  String _nombre = '';
  String _contrasena = '';
  String _correo = '';

  bool logueado() {
    return _nombre.isNotEmpty ? true : false;
  }

  String getIdUsuario() {
    return _idUsuario;
  }

  String getCorreo() {
    return _correo;
  }

  String getContrasena() {
    return _contrasena;
  }

  String getNombre() {
    return _nombre;
  }

  String getRol() {
    return _rolSeleccionado;
  }

  bool validar(String rol) {
    return _rolSeleccionado == rol ? true : false;
  }

  void setIdUsuario(String value) {
    _idUsuario = value;
  }

  void setContrasena(String value) {
    _contrasena = value;
  }

  void setCorreo(String value) {
    _correo = value;
  }

  void setRol(String? nuevoRol) {
    _rolSeleccionado = (nuevoRol == null) ? 'No role' : nuevoRol;
  }

  void setNombre(String value) {
    _nombre = value;
  }

  void clean() {
    _nombre = '';
    _contrasena = '';
    _correo = '';
    _rolSeleccionado = 'No role';
  }
}
