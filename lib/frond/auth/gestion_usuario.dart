import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/backend/auth/llamadas_api.dart';
import 'validar_entrada_campos.dart';
import '../estilos.dart';
import 'formulario_base.dart';

class GestionUsuario extends StatefulWidget {
  const GestionUsuario({super.key});
  @override
  State<GestionUsuario> createState() => _GestionUsuarioState();
}

class _GestionUsuarioState extends State<GestionUsuario>{
  //controladores
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Estado
  bool _esRegistro = false;
  bool _cargando = false;
  bool _ocultarContrasena = true;
  String _rolSeleccionado = 'sin_rol';
  String? _errorMensaje;

  @override
  void dispose(){
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _procesarFormulario() async {
    if(! _formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _errorMensaje = null;
    });

    try {
      if(_esRegistro){
        await signup(
          email: _correoController.text.trim(),
          password: _contrasenaController.text,
          rolSolicitado: _rolSeleccionado, 
        );
        if(!mounted) return;
        Navigator.pop(context, context.tr('gestionUsuario.accion.registro'));
      }else {
        await login(
          email: _correoController.text.trim(), 
          password: _contrasenaController.text
        );
        if(!mounted) return;
        Navigator.pop(context, context.tr('gestionUsuario.accion.sesion'));
      }
    } catch (e) {
      setState(() {
        debugPrint(e.toString());
        final error = e.toString();
        if(error.contains('statusCode: 400')){
          _errorMensaje = context.tr("mensajes.errorSupabase.400");
        } else if(error.contains('statusCode: null')){
           _errorMensaje = context.tr("mensajes.errorSupabase.null");
        } else if(error.contains('statusCode: 500')){
           _errorMensaje = context.tr("mensajes.errorSupabase.500");
        } else {
          _errorMensaje = context.tr("mensajes.desconocido");
        }
      });
    }finally{
      if(mounted){
        setState(() => _cargando = false);
      }
    }
  }

  @override   
  Widget build(BuildContext context){
    return FormularioAuthBase(
      formKey: _formKey, 
      cargando: _cargando, 
      titulo: _esRegistro ? 
      context.tr('gestionUsuario.titulo.registro') 
      : context.tr('gestionUsuario.titulo.login'), 
      icono: Icon(Icons.eco_outlined, size: 80, color: Estilos.verdePrincipal,), 
      campos: [
        SizedBox(height: Estilos.paddingGrande,),
        if(_esRegistro)
          CampoRol(
            rolSeleccionado: _rolSeleccionado, 
            onChanged: (rol) {
              setState(() {
                _rolSeleccionado = rol ?? 'sin_rol';
              });
            },
          ),
          SizedBox(height: Estilos.paddingGrande,),
          CampoCorreo(controlador: _correoController),
          SizedBox(height: Estilos.paddingGrande,),
          CampoContrasena(
            controladorC: _contrasenaController, 
            ocultar: _ocultarContrasena, 
            onCambiarVisibilidad: (){
              setState((){
                _ocultarContrasena = ! _ocultarContrasena;
              });
            }, 
            obligatorio: true,
          ),
      ], 
      acciones: [
        _esRegistro
        ? SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _procesarFormulario, 
            icon: const Icon(Icons.logout_outlined),
            label: Text(context.tr('gestionUsuario.botones.registro')),
          ),
        )
        : SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _procesarFormulario,
            icon: const Icon(Icons.logout_outlined), 
            label: Text(context.tr('gestionUsuario.botones.login')),
          ),
        ),
        SizedBox(height: Estilos.paddingGrande,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_outlined), 
            label: Text(context.tr('buttons.cancelar')),
          ),
        ),
      ],
      errorMensaje: (_errorMensaje != null) ? _errorMensaje : null,

      footer: Wrap(
        children: [
          Text(
            _esRegistro
              ? context.tr('gestionUsuario.textoCambio.tieneCuenta')
              : context.tr('gestionUsuario.textoCambio.noTieneCuenta'),
          ),
          TextButton(
            onPressed: (){
              setState(() {
                _esRegistro = ! _esRegistro;
              });
            }, 
            child: Text(
              _esRegistro
                ? context.tr('gestionUsuario.textoCambio.iniciarSesion')
                : context.tr('gestionUsuario.textoCambio.registrarse'),
            ),),
        ],
      ),
    );
  }
}