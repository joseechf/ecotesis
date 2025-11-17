import 'package:flutter/material.dart';
import 'estilos.dart';

// Clase con utilidades comunes para la aplicación
class Utilidades {
  // Muestra un diálogo de alerta con un título y mensaje
  static void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Muestra un diálogo de confirmación con acciones personalizadas
  static void mostrarConfirmacion(
    BuildContext context, 
    String titulo, 
    String mensaje, 
    VoidCallback onConfirmar, {
    String textoConfirmar = 'Aceptar',
    String textoCancelar = 'Cancelar',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(textoCancelar),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmar();
            },
            style: TextButton.styleFrom(
              foregroundColor: Estilos.verdeOscuro,
            ),
            child: Text(textoConfirmar),
          ),
        ],
      ),
    );
  }

  // Muestra un indicador de carga
  static void mostrarCargando(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Oculta el indicador de carga
  static void ocultarCargando(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Muestra un mensaje temporal (snackbar)
  static void mostrarMensaje(BuildContext context, String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color ?? Estilos.verdePrincipal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Estilos.radioBorde),
        ),
      ),
    );
  }

  // Valida si un correo electrónico tiene un formato válido
  static bool esCorreoValido(String correo) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(correo);
  }

  // Valida si una contraseña cumple con los requisitos mínimos
  static bool esContrasenaValida(String contrasena) {
    return contrasena.length >= 6;
  }

  // Formatea un texto para que la primera letra sea mayúscula
  static String capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
  }

  // Navega a una nueva pantalla con animación
  static void navegarConAnimacion(BuildContext context, Widget pantalla) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Estilos.animacionMedia,
        pageBuilder: (context, animation, secondaryAnimation) => pantalla,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // Cierra la pantalla actual con animación
  static void cerrarPantalla(BuildContext context) {
    Navigator.pop(context);
  }
}