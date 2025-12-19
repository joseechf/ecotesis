import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import '../iureutilizables/widgetEdicion.dart';
import 'usuarioPrueba.dart'; //este usuario es para pruebas

class CampoCorreo extends StatelessWidget {
  // Controlador externo para que funcione en cualquier pantalla
  final TextEditingController controlador;

  const CampoCorreo({Key? key, required this.controlador}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioLogueado usuario = usuarioLogueado();
    return CampoTextoPersonalizado(
      controlador: controlador,
      etiqueta: context.tr('gestionUsuario.campos.correo'),
      icono: Icons.email_outlined,
      tipoTeclado: TextInputType.emailAddress,

      // Validador de correo reutilizable
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.correoVacio');
        }

        final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        final bool correoValido = regex.hasMatch(value);

        if (!correoValido) {
          return context.tr('gestionUsuario.validaciones.correoInvalido');
        }
        usuario.setCorreo(value);
        return null;
      },
    );
  }
}

// Widget para el campo de texto de la contraseña
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
    final usuarioLogueado usuario = usuarioLogueado();
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
        usuario.setContrasena(value);
        return null;
      },
    );
  }
}

class CampoId extends StatelessWidget {
  final TextEditingController controllerId;
  const CampoId({Key? key, required this.controllerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final usuarioLogueado usuario = usuarioLogueado();
    return CampoTextoPersonalizado(
      controlador: controllerId,
      etiqueta: 'idUsuario',
      icono: Icons.privacy_tip,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return 'el id no puede ser vacio';
        }
        usuario.setIdUsuario(value);
        return null;
      },
    );
  }
}

// Widget para el campo de texto del nombre (solo en registro)
class CampoNombre extends StatelessWidget {
  final TextEditingController controladorN;
  const CampoNombre({Key? key, required this.controladorN}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioLogueado usuario = usuarioLogueado();
    return CampoTextoPersonalizado(
      controlador: controladorN,
      etiqueta: context.tr('gestionUsuario.campos.nombre'),
      icono: Icons.person_outlined,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.nombreVacio');
        }
        usuario.setNombre(value);
        return null;
      },
    );
  }
}

// Widget para el campo de selección de rol (solo en registro)
class CampoRol extends StatelessWidget {
  final String? rolSeleccionado;
  final ValueChanged<String?> onChanged;

  CampoRol({super.key, required this.rolSeleccionado, required this.onChanged});

  final mapRoles = {
    "Scientist": "Scientist",
    "Administrator": "Administrator",
    "No role": "No role",
  };

  final usuarioLogueado usuario = usuarioLogueado();
  @override
  Widget build(BuildContext context) {
    final listaroles = mapRoles.values.toList();
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
        SizedBox(height: Estilos.paddingPequeno),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Estilos.grisMedio),
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
            color: Estilos.blanco,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              //value: usuario.get(),
              value: rolSeleccionado,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Estilos.verdeOscuro),
              items:
                  listaroles.map((String rol) {
                    return DropdownMenuItem<String>(
                      value: rol,
                      child: Text(
                        rol,
                        style: TextStyle(
                          fontSize: Estilos.textoGrande,
                          color: Estilos.negro,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              /*onChanged: (String? nuevoRol) {
                usuario.set(nuevoRol);
              },*/
            ),
          ),
        ),
      ],
    );
  }
}
