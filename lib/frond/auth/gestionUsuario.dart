import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/backend/auth/llamadasApi.dart';
import 'validarEntradaCampos.dart';
import '../estilos.dart';
import './formularioBase.dart';
import '../iureutilizables/widgetEdicion.dart';

class GestionUsuario extends StatefulWidget {
  const GestionUsuario({Key? key}) : super(key: key);

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
        await signup(
          email: _correoController.text.trim(),
          password: _contrasenaController.text,
          rolSolicitado: _rolSeleccionado,
        );
      } else {
        await login(
          email: _correoController.text.trim(),
          password: _contrasenaController.text,
        );
      }
      //registro o autenticacion exitoso
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _cargando = false);
    }
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
