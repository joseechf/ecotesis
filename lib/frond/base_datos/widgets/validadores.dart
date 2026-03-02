class ValidadorTexto {
  static String? validaObligatorio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }

    if (value.length > 50) {
      return 'Maximo 50 caracteres';
    }

    final regex = RegExp(r'^[a-zA-Z]+$');

    if (!regex.hasMatch(value)) {
      return 'Solo letras (a-z, A-Z)';
    }

    return null;
  }

  static String? validaNoObligatorio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.length > 50) {
      return 'Maximo 50 caracteres';
    }

    final regex = RegExp(r'^[a-zA-Z]+$');

    if (!regex.hasMatch(value)) {
      return 'Solo letras (a-z, A-Z)';
    }

    return null;
  }
}
