import 'package:flutter/material.dart';

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

  String generarMensaje(OnError error, context){
    
    if(TypeError.validacion == error.type && error.source == 'API'){
      return '${context.tr("mensajes.erroresFormateados.api")}';
    }
    if(TypeError.database == error.type && error.source == 'API'){
      return '${context.tr("mensajes.erroresFormateados.apiobdremota")}';
    }
    if(TypeError.server == error.type && error.source == 'supabase'){
      return '${context.tr("mensajes.erroresFormateados.servidorauth")}';
    }
    if(error.source == 'mostrar'){
      return 'Error ${error.type} -- ${error.message}';
    }
    switch (error.type) {
      case TypeError.validacion:
        return '${context.tr("mensajes.erroresFormateados.invaliddata")}';
      case TypeError.authentication:
        return '${context.tr("mensajes.erroresFormateados.autenticacion")}';
      case TypeError.network:
        return '${context.tr("mensajes.erroresFormateados.internet")}';
      case TypeError.interface:
        return '${context.tr("mensajes.erroresFormateados.intentenuevamente")}';
      case TypeError.database:
        return '${context.tr("mensajes.erroresFormateados.bd")}';
      case TypeError.unknown:
        return '${context.tr("mensajes.erroresFormateados.unknow")} ${error.source}';
    }
    return 'Error desconocido - Unknown error';
  }

  List source = ['API','interface','supabase',''];