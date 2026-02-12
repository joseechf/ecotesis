import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import './formularioBase.dart';
import 'validarEntradaCampos.dart';
import '../../backend/auth/llamadasApi.dart';
import '../iureutilizables/widgetEdicion.dart';
import 'package:provider/provider.dart';
import '../../data/auth/session_provider.dart';

class EditarUsuario extends StatefulWidget {
  final String email;
  final String rolActual;
  final String estadoRol;

  const EditarUsuario({
    super.key,
    required this.email,
    required this.rolActual,
    required this.estadoRol,
  });

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _emailController;
  late final TextEditingController _rolController;
  late final TextEditingController _estadoRolController;
  final TextEditingController _passwordController = TextEditingController();

  bool _ocultarPassword = true;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email);
    _rolController = TextEditingController(text: widget.rolActual);
    _estadoRolController = TextEditingController(text: widget.estadoRol);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _rolController.dispose();
    _estadoRolController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await actualizarPassword(_passwordController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('mensajes.usuarioActualizado')),
          backgroundColor: Estilos.verdePrincipal,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool puedeEditarRol = widget.estadoRol == 'aprobado';

    return FormularioAuthBase(
      formKey: _formKey,
      cargando: _cargando,
      titulo: context.tr('titles.edicion'),
      icono: const Icon(
        Icons.person_outline,
        size: 80,
        color: Estilos.verdePrincipal,
      ),
      campos: [
        const SizedBox(height: Estilos.paddingGrande),
        // Email (solo lectura)
        CampoTextoPersonalizado(
          controlador: _emailController,
          etiqueta: context.tr('gestionUsuario.campos.correo'),
          icono: Icons.email_outlined,
          habilitado: false,
        ),
        const SizedBox(height: Estilos.paddingMedio),
        // Rol actual
        CampoTextoPersonalizado(
          controlador: _rolController,
          etiqueta: context.tr('gestionUsuario.campos.rol'),
          icono: Icons.security_outlined,
          habilitado: puedeEditarRol,
        ),
        const SizedBox(height: Estilos.paddingMedio),
        // Estado del rol (solo lectura)
        CampoTextoPersonalizado(
          controlador: _estadoRolController,
          etiqueta: context.tr('gestionUsuario.campos.estadoRol'),
          icono: Icons.info_outline,
          habilitado: false,
        ),
        const SizedBox(height: Estilos.paddingGrande),
        // Nueva contraseña
        CampoContrasena(
          controladorC: _passwordController,
          ocultar: _ocultarPassword,
          onCambiarVisibilidad: () {
            setState(() {
              _ocultarPassword = !_ocultarPassword;
            });
          },
        ),
      ],

      acciones: [
        BotonPersonalizado(
          texto: context.tr('buttons.editar'),
          icono: const Icon(Icons.save_outlined),
          onPressed: _guardarCambios,
        ),
        const SizedBox(height: Estilos.paddingGrande),
        BotonPersonalizado(
          texto: context.tr('buttons.delete'),
          color: 'rojo',
          icono: const Icon(Icons.delete_outline),
          onPressed: () async {
            final ok = await eliminarUsuario();
            if (!mounted) return;
            if (ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('mensaje.delete')),
                  backgroundColor: const Color.fromARGB(255, 243, 1, 1),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('mensaje.error')),
                  backgroundColor: const Color.fromARGB(255, 145, 143, 143),
                ),
              );
            }
          },
        ),
        const SizedBox(height: Estilos.paddingGrande),
        BotonPersonalizado(
          texto: context.tr('buttons.logout'),
          icono: const Icon(Icons.logout_outlined),
          onPressed: () {
            context.read<SessionProvider>().logout();
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: Estilos.paddingGrande),
        BotonPersonalizado(
          texto: context.tr('buttons.cancelar'),
          icono: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
