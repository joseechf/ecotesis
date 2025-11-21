import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import 'utilidades.dart';
import 'widgets.dart';
import '../home.dart';

import 'usuarioPrueba.dart'; //este usuario es para pruebas

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
  final TextEditingController _nombreController = TextEditingController();

  // Variables de estado
  bool _esRegistro = false;
  bool _ocultarContrasena = true;
  bool _cargando = false;
  usuarioLogueado miRol = usuarioLogueado();
  //String _rolSeleccionado = 'sin rol'; // Valor por defecto
  final _formKey = GlobalKey<FormState>();

  // Lista de roles disponibles
  final List<String> _rolesDisponibles = [
    'cientifico',
    'dueño de terreno',
    'estudiante',
    'sin rol',
  ];

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  // Método para validar y procesar el formulario
  void _procesarFormulario() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });

      // Simular una operación de red
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _cargando = false;
        });

        // Aquí iría la lógica de autenticación o registro
        if (_esRegistro) {
          // En el caso de registro, incluimos el rol seleccionado
          Utilidades.mostrarMensaje(
            context,
            context.tr(
              'gestionUsuario.mensajes.registroExitoso',
              namedArgs: {'rol': Utilidades.capitalizar(miRol.get())},
            ),
          );
        } else {
          Utilidades.mostrarMensaje(
            context,
            context.tr('gestionUsuario.mensajes.loginExitoso'),
          );
        }

        // Redirigir a la página principal después de iniciar sesión o registrarse
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false,
        );
      });
    }
  }

  // Widget para el campo de texto del correo
  Widget _campoCorreo() {
    return CampoTextoPersonalizado(
      controlador: _correoController,
      etiqueta: context.tr('gestionUsuario.campos.correo'),
      icono: Icons.email_outlined,
      tipoTeclado: TextInputType.emailAddress,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.correoVacio');
        }
        if (!Utilidades.esCorreoValido(value)) {
          return context.tr('gestionUsuario.validaciones.correoInvalido');
        }
        return null;
      },
    );
  }

  // Widget para el campo de texto de la contraseña
  Widget _campoContrasena() {
    return CampoTextoPersonalizado(
      controlador: _contrasenaController,
      etiqueta: context.tr('gestionUsuario.campos.contrasena'),
      icono: Icons.lock_outlined,
      esContrasena: true,
      ocultarTexto: _ocultarContrasena,
      onPressedIcono: () {
        setState(() {
          _ocultarContrasena = !_ocultarContrasena;
        });
      },
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.contrasenaVacia');
        }
        if (!Utilidades.esContrasenaValida(value)) {
          return context.tr('gestionUsuario.validaciones.contrasenaInvalida');
        }
        return null;
      },
    );
  }

  // Widget para el campo de texto del nombre (solo en registro)
  Widget _campoNombre() {
    if (!_esRegistro) return const SizedBox();

    return CampoTextoPersonalizado(
      controlador: _nombreController,
      etiqueta: context.tr('gestionUsuario.campos.nombre'),
      icono: Icons.person_outlined,
      validador: (value) {
        if (value == null || value.isEmpty) {
          return context.tr('gestionUsuario.validaciones.nombreVacio');
        }
        return null;
      },
    );
  }

  // Widget para el campo de selección de rol (solo en registro)
  Widget _campoRol() {
    if (!_esRegistro) return const SizedBox();

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
              value: miRol.get(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Estilos.verdeOscuro),
              items:
                  _rolesDisponibles.map((String rol) {
                    return DropdownMenuItem<String>(
                      value: rol,
                      child: Text(
                        context.tr(
                          'gestionUsuario.roles.${rol.replaceAll(' ', '')}',
                        ),
                        style: TextStyle(
                          fontSize: Estilos.textoGrande,
                          color: Estilos.negro,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (String? nuevoRol) {
                setState(() {
                  miRol.set(nuevoRol!);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget para el botón principal
  Widget _botonPrincipal() {
    return BotonPersonalizado(
      texto:
          _esRegistro
              ? context.tr('gestionUsuario.botones.registro')
              : context.tr('gestionUsuario.botones.login'),
      onPressed: _procesarFormulario,
      cargando: _cargando,
    );
  }

  // Widget para el texto de cambio entre login y registro
  Widget _textoCambioModo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    return Scaffold(
      body: Container(
        decoration: Estilos.decoracionCaja,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Estilos.paddingGrande),
            child: TarjetaAnimada(
              hijo: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo o título
                    Icon(
                      Icons.eco_outlined,
                      size: 80,
                      color: Estilos.verdePrincipal,
                    ),
                    SizedBox(height: Estilos.paddingMedio),
                    TextoAnimado(
                      texto:
                          _esRegistro
                              ? context.tr('gestionUsuario.titulo.registro')
                              : context.tr('gestionUsuario.titulo.login'),
                      estilo: TextStyle(
                        fontSize: Estilos.textoMuyGrande,
                        fontWeight: FontWeight.bold,
                        color: Estilos.verdeOscuro,
                      ),
                    ),
                    SizedBox(height: Estilos.paddingMuyGrande),

                    // Campos del formulario
                    _campoNombre(),
                    SizedBox(height: Estilos.paddingMedio),
                    _campoRol(),
                    SizedBox(height: Estilos.paddingMedio),
                    _campoCorreo(),
                    SizedBox(height: Estilos.paddingMedio),
                    _campoContrasena(),
                    SizedBox(height: Estilos.paddingGrande),

                    // Botón principal
                    _botonPrincipal(),

                    // Indicador de carga
                    if (_cargando) ...[
                      SizedBox(height: Estilos.paddingMedio),
                      IndicadorCarga(
                        mensaje: context.tr(
                          'gestionUsuario.mensajes.procesando',
                        ),
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
          ),
        ),
      ),
    );
  }
}
