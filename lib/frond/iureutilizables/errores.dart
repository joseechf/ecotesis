import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OnError {
  final String status;
  final String message;
  final String type;
  final String? source;
  OnError({
    required this.status,
    required this.message,
    required this.type,
    this.source,
  });

  factory OnError.fromJson(Map<String,dynamic> json, String? recurso){
    return OnError(
      status: json['status'].toString(), 
      type: json['type'].toString(), 
      message: json['message'],
      source: json['source']?.toString() ?? recurso,
    );
  }
}

class TypeError {
  static const String validacion = 'validation';
  static const String database = 'database';
  static const String server = 'server'; 
  static const String network = 'network';
  static const String interface = 'interface';
  static const String authentication = 'authentication';
  static const String unknown = 'unknown';
}

  void mostrarErrorUI(BuildContext context, OnError error) {
    debugPrint(' ERROR REAL UI: ${error.status} | ${error.source} | ${error.type} | message: ${error.message}',);
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Error'),
        content: Text(generarMensaje(error,context)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), 
          child: const Text('Aceptar'), 
          ),
           
        ],
      ),
    );
  }

  String generarMensaje(OnError error, BuildContext context){
    
    if(TypeError.validacion == error.type && error.source == 'API'){
      if(context.mounted)
        {
          return context.tr("mensajes.erroresFormateados.api");
      }else{
          return 'La validación de la API rechaza los datos';
      }
    }
    if(TypeError.database == error.type && error.source == 'API'){
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.apiobdremota");
      }else{
          return 'Error en el API o la base de datos remota';
      }
    }
    if(TypeError.server == error.type && error.source == 'supabase'){
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.servidorauth");
      }else{
          return 'Error en el servidor de autenticación';
      }
    }
    if(error.source == 'mostrar'){
      return 'Error ${error.type} -- ${error.message}';
    }
    switch (error.type) {
      case TypeError.validacion:
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.invaliddata");
      }else{
          return 'Datos ingresados invalidos';
      }
      case TypeError.authentication:
      if(context.mounted)
      {
       return context.tr("mensajes.erroresFormateados.autenticacion");
      }else{
          return 'La autenticación falló';
      }
      case TypeError.network:
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.internet");
      }else{
          return 'Error en la conexión a internet';
      }
      case TypeError.interface:
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.intentenuevamente");
      }else{
          return 'Error en la aplicación intentelo nuevamente';
      }
      case TypeError.database:
      if(context.mounted)
      {
        return context.tr("mensajes.erroresFormateados.bd");
      }else{
          return 'Error en la base de datos local o remota';
      }  
      case TypeError.unknown:
      if(context.mounted)
      {
        return '${context.tr("mensajes.erroresFormateados.unknow")} ${error.source}';
      }else{
          return 'Error desconocido - Unknown error';
      }
        
    }
    return 'Error desconocido - Unknown error';
  }

  List source = ['API','interface','supabase',''];