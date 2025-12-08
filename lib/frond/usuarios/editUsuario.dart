import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import '../iureutilizables/widgetEdicion.dart';
import '../iureutilizables/widgetpersonalizados.dart';
import '../static/home.dart';

import 'validarEntradaCampos.dart';
import 'usuarioPrueba.dart'; //este usuario es para pruebas

class EditUsuario extends StatefulWidget {
  const EditUsuario({Key? key}) : super(key: key);

  @override
  State<EditUsuario> createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  // Controladores para los campos de texto
  late TextEditingController _correoController = TextEditingController();
  late TextEditingController _contrasenaController = TextEditingController();
  late TextEditingController _nombreController = TextEditingController();
  bool _ocultarContrasena = true;
  bool _cargando = false;
  usuarioLogueado miRol = usuarioLogueado();
  //String _rolSeleccionado = 'sin rol'; // Valor por defecto
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: miRol.logueado() ? miRol.getNombre() : '',
    );
    _correoController = TextEditingController(
      text: miRol.logueado() ? miRol.getCorreo() : '',
    );
    _contrasenaController = TextEditingController(
      text: miRol.logueado() ? miRol.getContrasena() : '',
    );
  }

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  //  validar y procesar el formulario
  void _procesarFormulario() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });
      //esto del delayed debe cambiar cuando ponga una consulta bd real
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _cargando = false;
        });
        SnackBar(
          content: Text('Edicion completa'),
          backgroundColor: Estilos.verdePrincipal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBorde),
          ),
        );

        // Redirigir a la página principal después de iniciar sesión o registrarse
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false,
        );
      });
    }
  }

  void _eliminarUsuario() {
    final usuarioLogueado usuario = usuarioLogueado();
    usuario.set('No role');
    usuario.setContrasena('');
    usuario.setCorreo('');
    usuario.setNombre('');
    SnackBar(
      content: Text('Usuario eliminado'),
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Estilos.radioBorde),
      ),
    );
    // Redirigir a la página principal después de iniciar sesión o registrarse
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyHomePage()),
      (route) => false,
    );
  }

  // Widget para el botón principal
  Widget _botonPrincipal() {
    return Center(
      child: Column(
        children: [
          BotonPersonalizado(
            texto: context.tr('buttons.editar'),
            onPressed: _procesarFormulario,
            icono: Icon(Icons.edit, color: Estilos.blanco),
            ancho: 200,
          ),
          SizedBox(height: 20),
          BotonPersonalizado(
            texto: context.tr('buttons.delete'),
            onPressed: _eliminarUsuario,
            icono: Icon(Icons.delete, color: Estilos.blanco),
            ancho: 200,
            color: 'rojo',
          ),
          SizedBox(height: 20),
          BotonPersonalizado(
            texto: context.tr('buttons.cancelar'),
            onPressed:
                () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                    (route) => false,
                  ),
                },
            icono: Icon(Icons.cancel, color: Estilos.blanco),
            ancho: 200,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // borde como en tu tarjeta
      ),

      // Título de la tarjeta (vacío)
      title: Column(
        children: [
          Icon(Icons.eco_outlined, size: 80, color: Estilos.verdePrincipal),
          SizedBox(height: Estilos.paddingMedio),
          Text("Editar Usuario"),
        ],
      ),

      // Contenido desplazable (vacío)
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campos del formulario
            SizedBox(height: Estilos.paddingMedio),
            CampoNombre(controladorN: _nombreController),
            SizedBox(height: Estilos.paddingMedio),
            CampoCorreo(controlador: _correoController),
            SizedBox(height: Estilos.paddingMedio),
            CampoContrasena(
              controladorC: _contrasenaController,
              ocultar: _ocultarContrasena,
              onCambiarVisibilidad: () {
                setState(() {
                  _ocultarContrasena = !_ocultarContrasena;
                });
              },
            ),
            SizedBox(height: Estilos.paddingMedio),
            CampoRol(),
            SizedBox(height: Estilos.paddingGrande),
            _botonPrincipal(),
          ],
        ),
      ),
    );
  }
}
