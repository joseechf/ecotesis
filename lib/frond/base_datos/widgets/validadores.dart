class ValidadorTexto {
  static final RegExp _regexTexto = RegExp(r'^[\p{L}\s.-]+$', unicode: true);

  static String? validaObligatorio(String? value) {
    if (value == null) return 'Campo obligatorio';

    final texto = value.trim();

    if (texto.isEmpty) {
      return 'Campo obligatorio';
    }

    if (texto.length > 100) {
      return 'Máximo 100 caracteres';
    }

    if (!_regexTexto.hasMatch(texto)) {
      return 'Solo letras, espacios, puntos o guiones';
    }

    return null;
  }

  static String? validaNoObligatorio(String? value) {
    if (value == null) return null;

    final texto = value.trim();

    if (texto.isEmpty) {
      return null;
    }

    if (texto.length > 100) {
      return 'Máximo 100 caracteres';
    }

    if (!_regexTexto.hasMatch(texto)) {
      return 'Solo letras, espacios, puntos o guiones';
    }

    return null;
  }
}
