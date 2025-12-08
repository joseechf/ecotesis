class usuarioLogueado {
  static final usuarioLogueado _instancia = usuarioLogueado._internal();

  usuarioLogueado._internal();

  factory usuarioLogueado() {
    return _instancia;
  }

  String _rolSeleccionado = 'No role';
  String _nombre = '';
  String _contrasena = '';
  String _correo = '';

  bool logueado() {
    return _nombre.isNotEmpty ? true : false;
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

  String get() {
    return _rolSeleccionado;
  }

  bool validar(rol) {
    return _rolSeleccionado == rol ? true : false;
  }

  void setContrasena(value) {
    _contrasena = value;
  }

  void setCorreo(value) {
    _correo = value;
  }

  void set(nuevoRol) {
    _rolSeleccionado = nuevoRol;
  }

  void setNombre(value) {
    _nombre = value;
  }
}
