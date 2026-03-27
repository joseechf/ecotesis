import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import 'formulario_base.dart';
import 'validar_entrada_campos.dart';
import '../../backend/auth/llamadas_api.dart';
import '../iureutilizables/widget_edicion.dart';
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

  late final TextEditingController _emailController;
  late String _rolController;
  late final TextEditingController _estadoRolController;
  final TextEditingController _passwordController = TextEditingController();

  bool _ocultarPassword = true;
  bool _cargando = false;
  String? _errorMensaje;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email);
    _rolController = widget.rolActual;
    _estadoRolController = TextEditingController(text: widget.estadoRol);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _estadoRolController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _errorMensaje = null;
    });
    try {
      if (_passwordController.text.isNotEmpty) {
        await actualizarPassword(_passwordController.text);
      }
      if (_rolController != widget.rolActual) {
        debugPrint('$_rolController solicitando rol ...');
        await solicitarNuevoRol(_rolController);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMensaje = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool puedeEditarRol =
        widget.estadoRol == 'aprobado' || widget.estadoRol == 'rechazado';

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
        DropdownButtonFormField<String>(
          initialValue: _rolController,
          items: _dropItems(context, [
            'cientifico',
            'administrador',
            'sin_rol',
          ]),
          onChanged:
              puedeEditarRol
                  ? (v) => setState(() => _rolController = v!)
                  : null,
          decoration: InputDecoration(
            labelText: context.tr('gestionUsuario.campos.rol'),
          ),
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
          obligatorio: false,
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
            if (ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('mensajes.delete')),
                  backgroundColor: Estilos.red,
                ),
              );
              Navigator.pop(context, "usuario_eliminado");
            }
          },
        ),
        const SizedBox(height: Estilos.paddingGrande),
        BotonPersonalizado(
          texto: context.tr('buttons.logout'),
          icono: const Icon(Icons.logout_outlined),
          onPressed: () {
            context.read<SessionProvider>().logout();
            Navigator.pop(context, "logout");
          },
        ),
        const SizedBox(height: Estilos.paddingGrande),
        BotonPersonalizado(
          texto: context.tr('buttons.cerrar'),
          icono: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      errorMensaje: (_errorMensaje != null) ? _errorMensaje : null,
    );
  }

  List<DropdownMenuItem<String>> _dropItems(
    BuildContext ctx,
    List<String> values,
  ) =>
      values
          .map(
            (v) => DropdownMenuItem(
              value: v,
              child: Text(ctx.tr('gestionUsuario.roles.$v')),
            ),
          )
          .toList();
}
