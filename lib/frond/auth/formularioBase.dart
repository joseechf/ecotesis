import 'package:flutter/material.dart';
import '../estilos.dart';

class FormularioAuthBase extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool cargando;
  final String titulo;
  final Widget icono;
  final List<Widget> campos;
  //final String textoBoton;
  //final VoidCallback onSubmit;
  final List<Widget> acciones;
  final Widget? footer;

  const FormularioAuthBase({
    super.key,
    required this.formKey,
    required this.cargando,
    required this.titulo,
    required this.icono,
    required this.campos,
    //required this.textoBoton,
    //required this.onSubmit,
    required this.acciones,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          icono,
          const SizedBox(height: Estilos.paddingMedio),
          Text(titulo),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...campos,

              const SizedBox(height: Estilos.paddingGrande),
              ...acciones,
              const SizedBox(height: Estilos.paddingGrande),

              /*BotonPersonalizado(
                texto: textoBoton,
                onPressed: cargando ? () {} : onSubmit,
                ancho: 200,
              ),*/
              const SizedBox(height: Estilos.paddingMedio),

              if (cargando)
                const CircularProgressIndicator()
              else if (footer != null)
                footer!,
            ],
          ),
        ),
      ),
    );
  }
}
