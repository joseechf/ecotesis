class usuarioLogueado {
  static final usuarioLogueado _instancia = usuarioLogueado._internal();

  usuarioLogueado._internal();

  factory usuarioLogueado() {
    return _instancia;
  }

  String _rolSeleccionado = 'No role';

  String get() {
    return _rolSeleccionado;
  }

  bool validar(rol) {
    return _rolSeleccionado == rol ? true : false;
  }

  void set(nuevoRol) {
    _rolSeleccionado = nuevoRol;
  }
}
