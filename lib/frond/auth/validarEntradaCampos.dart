import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import '../iureutilizables/widgetEdicion.dart';

class CampoCorreo extends StatelessWidget {
  final TextEditingController controlador;

  const CampoCorreo({Key? key, required this.controlador}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CampoTextoPersonalizado(
      controlador: controlador,
      etiqueta: context.tr('gestionUsuario.campos.correo'),
      icono: Icons.email_outlined,
      tipoTeclado: TextInputType.emailAddress,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.correoVacio');
        }

        final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!regex.hasMatch(value)) {
          return context.tr('gestionUsuario.validaciones.correoInvalido');
        }

        return null;
      },
    );
  }
}

class CampoContrasena extends StatelessWidget {
  final TextEditingController controladorC;
  final bool ocultar;
  final VoidCallback onCambiarVisibilidad;

  const CampoContrasena({
    super.key,
    required this.controladorC,
    required this.ocultar,
    required this.onCambiarVisibilidad,
  });

  @override
  Widget build(BuildContext context) {
    return CampoTextoPersonalizado(
      controlador: controladorC,
      etiqueta: context.tr('gestionUsuario.campos.contrasena'),
      icono: Icons.lock_outlined,
      esContrasena: true,
      ocultarTexto: ocultar,
      onPressedIcono: onCambiarVisibilidad,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.contrasenaVacia');
        }
        if (value.length < 6) {
          return context.tr('gestionUsuario.validaciones.contrasenaInvalida');
        }
        return null;
      },
    );
  }
}

class CampoRol extends StatelessWidget {
  final String? rolSeleccionado;
  final ValueChanged<String?> onChanged;

  const CampoRol({
    super.key,
    required this.rolSeleccionado,
    required this.onChanged,
  });

  // value = lo que se guarda en BD
  // label = lo que ve el usuario
  static const roles = [
    {'value': 'cientifico', 'label': 'Científico'},
    {'value': 'administrador', 'label': 'Administrador'},
    {'value': 'sin_rol', 'label': 'Sin rol'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('gestionUsuario.campos.rol'),
          style: TextStyle(
            fontSize: Estilos.textoMedio,
            color: Estilos.verdeOscuro,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Estilos.paddingPequeno),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Estilos.grisMedio),
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
            color: Estilos.blanco,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: rolSeleccionado,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Estilos.verdeOscuro),
              items:
                  roles.map((rol) {
                    return DropdownMenuItem<String>(
                      value: rol['value'],
                      child: Text(
                        rol['label']!,
                        style: TextStyle(
                          fontSize: Estilos.textoGrande,
                          color: Estilos.negro,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
