import 'package:ecoazuero/backend/login/llamadasApi.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import '../iureutilizables/widgetEdicion.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import '../static/home.dart';

import 'usuarioPrueba.dart'; //este usuario es para pruebas
import 'validarEntradaCampos.dart';

// Pantalla principal de gestión de usuarios con opciones de registro y login
class GestionUsuario extends StatefulWidget {
  const GestionUsuario({Key? key}) : super(key: key);

  @override
  State<GestionUsuario> createState() => _GestionUsuarioState();
}

class _GestionUsuarioState extends State<GestionUsuario> {
  // Controladores para los campos de texto
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  usuarioLogueado miusuarioLogueado = usuarioLogueado();
  String? _rolSeleccionado = 'No role';

  // Variables de estado
  bool _esRegistro = false;
  bool _ocultarContrasena = true;
  bool _cargando = false;
  //String _rolSeleccionado = 'sin rol'; // Valor por defecto
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    _idController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  //  validar y procesar el formulario
  Future<void> _procesarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });
      setState(() {
        _cargando = false;
      });
      if (_esRegistro) {
        try {
          final respuesta = registro();
          print('respuesta del registro: $respuesta');
        } catch (e) {
          print('registro jodido $e');
          SnackBar(content: Text('$e'));
        }
        SnackBar(
          content: Text(context.tr('gestionUsuario.mensajes.registroExitoso')),
          backgroundColor: Estilos.verdePrincipal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
          ),
        );
      } else {
        try {
          print('antes del login');
          final respuesta = login();
          print('respuesta del login: $respuesta');

          SnackBar(
            content: Text(context.tr('gestionUsuario.mensajes.loginExitoso')),
            backgroundColor: Estilos.verdePrincipal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Estilos.radioBorde),
            ),
          );
        } catch (e) {
          print('login jodido $e');
          SnackBar(content: Text('$e'));
        }
      }

      // Redirigir a la página principal después de iniciar sesión o registrarse
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false,
      );
    }
  }

  // Widget para el botón principal
  Widget _botonPrincipal() {
    return BotonPersonalizado(
      texto:
          _esRegistro
              ? context.tr('gestionUsuario.botones.registro')
              : context.tr('gestionUsuario.botones.login'),
      onPressed: () async {
        await _procesarFormulario();
      },
      icono: Icon(Icons.save, color: Estilos.blanco),
      ancho: 200,
    );
  }

  // Widget para el texto de cambio entre login y registro
  Widget _textoCambioModo() {
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.center,
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
            style: TextStyle(
              color: Estilos.verdeOscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _rolSeleccionado = miusuarioLogueado.getRol();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // borde como en tu tarjeta
      ),

      // Título de la tarjeta (vacío)
      title: Column(
        children: [
          Icon(Icons.eco_outlined, size: 80, color: Estilos.verdePrincipal),
          SizedBox(height: Estilos.paddingMedio),
          _esRegistro
              ? Text(context.tr('gestionUsuario.titulo.registro'))
              : Text(context.tr('gestionUsuario.titulo.login')),
        ],
      ),

      // Contenido desplazable (vacío)
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campos del formulario
              (_esRegistro)
                  ? CampoNombre(controladorN: _nombreController)
                  : Text(''),
              SizedBox(height: Estilos.paddingMedio),
              (_esRegistro)
                  ? CampoRol(
                    rolSeleccionado: _rolSeleccionado,
                    onChanged: (nuevoRol) {
                      setState(() {
                        _rolSeleccionado = nuevoRol;
                        miusuarioLogueado.setRol(nuevoRol);
                      });
                    },
                  )
                  : Text(''),
              SizedBox(height: Estilos.paddingMedio),
              CampoCorreo(controlador: _correoController),
              SizedBox(height: Estilos.paddingMedio),
              (_esRegistro)
                  ? CampoContrasena(
                    controladorC: _contrasenaController,
                    ocultar: _ocultarContrasena,
                    onCambiarVisibilidad: () {
                      setState(() {
                        _ocultarContrasena = !_ocultarContrasena;
                      });
                    },
                  )
                  : Text(''),
              (!_esRegistro) ? CampoId(controllerId: _idController) : Text(''),
              SizedBox(height: Estilos.paddingGrande),

              // Botón principal
              _botonPrincipal(),

              // Indicador de carga
              if (_cargando) ...[
                SizedBox(height: Estilos.paddingMedio),
                IndicadorCarga(
                  mensaje: context.tr('gestionUsuario.mensajes.procesando'),
                ),
              ] else ...[
                SizedBox(height: Estilos.paddingMedio),
                // Texto para cambiar entre login y registro
                _textoCambioModo(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
