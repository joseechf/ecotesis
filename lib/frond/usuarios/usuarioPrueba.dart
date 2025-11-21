class usuarioLogueado {
  // 1. Instancia única privada
  static final usuarioLogueado _instancia = usuarioLogueado._internal();

  // 2. Constructor privado
  usuarioLogueado._internal();

  // 3. Factory que siempre devuelve la MISMA instancia
  factory usuarioLogueado() {
    return _instancia;
  }

  String _rolSeleccionado = 'sin rol';

  String get() {
    return _rolSeleccionado;
  }

  bool validar() {
    return _rolSeleccionado == 'sin rol' ? false : true;
  }

  void set(nuevoRol) {
    _rolSeleccionado = nuevoRol;
  }
}
