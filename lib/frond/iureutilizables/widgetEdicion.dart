import 'package:flutter/material.dart';
import '../estilos.dart';

// Botón simple con estilos de estilos.dart
class BotonPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Widget? icono;
  final double? ancho;
  final String? color;

  const BotonPersonalizado({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.ancho,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: (ancho != null) ? ancho : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (color == 'rojo')
                  ? const Color.fromARGB(255, 255, 0, 0)
                  : Estilos.verdePrincipal,
          foregroundColor: Estilos.blanco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icono != null) ...[icono!, const SizedBox(width: 8)],
            Text(
              texto,
              style: TextStyle(
                fontSize: Estilos.textoGrande,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de campo de texto personalizado
class CampoTextoPersonalizado extends StatelessWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final IconData? icono;
  final bool esContrasena;
  final bool ocultarTexto;
  final VoidCallback? onPressedIcono;
  final TextInputType? tipoTeclado;
  final String? Function(String?)? validador;
  final int? maxLineas;

  const CampoTextoPersonalizado({
    Key? key,
    required this.controlador,
    required this.etiqueta,
    this.icono,
    this.esContrasena = false,
    this.ocultarTexto = true,
    this.onPressedIcono,
    this.tipoTeclado,
    this.validador,
    this.maxLineas = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena ? ocultarTexto : false,
      keyboardType: tipoTeclado,
      maxLines: maxLineas,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono != null ? Icon(icono) : null,
        suffixIcon:
            esContrasena
                ? IconButton(
                  icon: Icon(
                    ocultarTexto
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: onPressedIcono,
                )
                : null,
      ),
      validator: validador,
    );
  }
}
