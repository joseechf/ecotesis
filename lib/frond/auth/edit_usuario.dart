import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';
import 'formulario_base.dart';
import 'validar_entrada_campos.dart';
import '../../backend/auth/llamadas_api.dart';
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
  void dispose(){
    _emailController.dispose();
    _estadoRolController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<bool> _guardarCambios() async {
    if(! _formKey.currentState!.validate()) return false;
    setState(() {
      _cargando = true;
      _errorMensaje = null;
    });
    try {
      if (_passwordController.text.isNotEmpty) {
        await actualizarPassword(_passwordController.text);
      }
      if(_rolController != widget.rolActual) {
        debugPrint('$_rolController solicitando rol ... ');
        await solicitarNuevoRol(_rolController);
      }
      return true;
    } catch (e) {
      if(!mounted) return false;
      setState(() {
        _errorMensaje = e.toString();
      });
      return false;
    } finally {
      if(mounted) {
         setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext content) {
    final bool puedeEditarRol = widget.estadoRol == 'aprobado' || widget.estadoRol == 'rechazado';
    return FormularioAuthBase(
      formKey: _formKey,
      cargando: _cargando,
      titulo: content.tr('titles.edicion'), 
      icono: const Icon(
        Icons.person_outline,
        size: 80,
        color: Estilos.verdePrincipal,
      ), 
      campos: [
        const SizedBox(height: Estilos.paddingGrande,),
        TextFormField(
          controller: _emailController,
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
            labelText: context.tr('gestionUsuario.campos.correo'),
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: Estilos.paddingMedio,),
        DropdownButtonFormField<String>(
          initialValue: _rolController,
          items: _dropItems(context, [
            'cientifico',
            'administrador',
            'sin_rol',
          ]),
          onChanged: 
          puedeEditarRol
             ? (v) => setState(()=> _rolController = v!)
             : null,
          decoration: InputDecoration(
            labelText: content.tr('gestionUsuario.campos.rol'),
          ),
          ),
          const SizedBox(height: Estilos.paddingMedio,),
          TextFormField(
            controller: _estadoRolController,
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              labelText: context.tr('gestionUsuario.campos.estadoRol'),
              prefixIcon: const Icon(Icons.info_outline),
            ),
          ),
          const SizedBox(height: Estilos.paddingMedio,),
          CampoContrasena(
            controladorC: _passwordController, 
            ocultar: _ocultarPassword, 
            onCambiarVisibilidad: (){
              setState(() {
                _ocultarPassword = ! _ocultarPassword;
              });
            },
             obligatorio: false
             ),
      ], 
      acciones: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final ok = await _guardarCambios();
              if(ok && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('mensajes.nice')),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }, 
            icon: const Icon(Icons.save_outlined),
            label: Text(context.tr('buttons.editar')),
            ),
        ),
        const SizedBox(height: Estilos.paddingMedio,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final ok = await eliminarUsuario();
              if(ok && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('mensaje.delete')),
                  backgroundColor: Estilos.red,
                  ),
                );
                Navigator.pop(context,"usuario_eliminado");
              }
            },
            icon: const Icon(Icons.delete_outline),
             label: Text(content.tr('buttons.delete')),
            ),
        ),
        const SizedBox(height: Estilos.paddingGrande,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(onPressed: (){
            content.read<SessionProvider>().logout();
            Navigator.pop(context,"logout");
          },
          icon: const Icon(Icons.logout_outlined),
          label: Text(content.tr('buttons.logout')),
        ),
        ),
        const SizedBox(height: Estilos.paddingGrande,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_outlined),
            label: Text(context.tr('buttons.cerrar')),
          ),
        ),
      ],
      errorMensaje: (_errorMensaje != null) ? _errorMensaje : null,
      );
  }
  List<DropdownMenuItem<String>> _dropItems(
    BuildContext ctx,
    List<String> values,
  ) => values.map((v) => DropdownMenuItem(
    value: v,
    child: Text(ctx.tr('gestionUsuario.roles.$v')),
  ),).toList();
}