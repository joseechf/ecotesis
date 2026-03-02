import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/backend/auth/llamadas_api.dart';
import 'validar_entrada_campos.dart';
import '../estilos.dart';
import 'formulario_base.dart';
import '../iureutilizables/widget_edicion.dart';

class GestionUsuario extends StatefulWidget {
  const GestionUsuario({super.key});

  @override
  State<GestionUsuario> createState() => _GestionUsuarioState();
}

class _GestionUsuarioState extends State<GestionUsuario> {
  // Controladores
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Estado
  bool _esRegistro = false;
  bool _cargando = false;
  bool _ocultarContrasena = true;
  String _rolSeleccionado = 'sin_rol';

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _procesarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      if (_esRegistro) {
        final response = await signup(
          email: _correoController.text.trim(),
          password: _contrasenaController.text,
          rolSolicitado: _rolSeleccionado,
        );

        if (!mounted) return;

        if (response.session == null) {
          Navigator.pop(context, "Registro exitoso");
        } else {
          Navigator.pop(context, "Registro fallido");
        }
      } else {
        final response = await login(
          email: _correoController.text.trim(),
          password: _contrasenaController.text,
        );

        if (!mounted) return;

        if (response.session != null) {
          Navigator.pop(context, "Inicio de sesión exitoso");
        }
      }
    } catch (e) {
      if (!mounted) return;

      final mensajeError = _traducirError(e.toString());

      Navigator.pop(context, "ERROR:$mensajeError");
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  String _traducirError(String error) {
    if (error.contains('Invalid login credentials')) {
      return "Correo o contraseña incorrectos.";
    }

    if (error.contains('Email not confirmed')) {
      return "Debes confirmar tu correo antes de iniciar sesión.";
    }

    if (error.contains('User already registered')) {
      return "Este correo ya está registrado.";
    }

    if (error.contains('Password should be at least')) {
      return "La contraseña es demasiado corta.";
    }

    if (error.contains('Network')) {
      return "Error de conexión. Verifica tu internet.";
    }

    return "Ocurrió un error inesperado.";
  }

  @override
  Widget build(BuildContext context) {
    return FormularioAuthBase(
      formKey: _formKey,
      cargando: _cargando,
      titulo:
          _esRegistro
              ? context.tr('gestionUsuario.titulo.registro')
              : context.tr('gestionUsuario.titulo.login'),
      icono: Icon(Icons.eco_outlined, size: 80, color: Estilos.verdePrincipal),

      campos: [
        SizedBox(height: 20),
        if (_esRegistro)
          CampoRol(
            rolSeleccionado: _rolSeleccionado,
            onChanged: (rol) {
              setState(() {
                _rolSeleccionado = rol ?? 'sin_rol';
              });
            },
          ),
        SizedBox(height: 20),
        CampoCorreo(controlador: _correoController),
        SizedBox(height: 20),
        CampoContrasena(
          controladorC: _contrasenaController,
          ocultar: _ocultarContrasena,
          onCambiarVisibilidad: () {
            setState(() {
              _ocultarContrasena = !_ocultarContrasena;
            });
          },
        ),
      ],

      acciones: [
        _esRegistro
            ? BotonPersonalizado(
              texto: context.tr('gestionUsuario.botones.registro'),
              icono: const Icon(Icons.logout_outlined),
              onPressed: _procesarFormulario,
            )
            : BotonPersonalizado(
              texto: context.tr('gestionUsuario.botones.login'),
              icono: const Icon(Icons.logout_outlined),
              onPressed: _procesarFormulario,
            ),
      ],

      footer: Wrap(
        children: [
          Text(
            _esRegistro
                ? context.tr('gestionUsuario.textoCambio.tieneCuenta')
                : context.tr('gestionUsuario.textoCambio.noTieneCuenta'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _esRegistro = !_esRegistro;
              });
            },
            child: Text(
              _esRegistro
                  ? context.tr('gestionUsuario.textoCambio.iniciarSesion')
                  : context.tr('gestionUsuario.textoCambio.registrarse'),
            ),
          ),
        ],
      ),
    );
  }
}
