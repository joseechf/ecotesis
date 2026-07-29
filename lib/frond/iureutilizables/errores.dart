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
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(generarMensaje(error)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), 
          child: const Text('Aceptar'),
          ), 
        ],
      ),
    );
  }

  String generarMensaje(OnError error){
    
    if(TypeError.validacion == error.type && error.source == 'API'){
      return 'La validación de la API rechaza los datos';
    }
    if(TypeError.database == error.type && error.source == 'API'){
      return 'Error en el API o la base de datos remota';
    }
    if(TypeError.server == error.type && error.source == 'supabase'){
      return 'Error en el servidor de autenticación';
    }
    if(error.source == 'mostrar'){
      return 'Error ${error.type} -- ${error.message}';
    }
    switch (error.type) {
      case TypeError.validacion:
        return 'Datos ingresados invalidos';
      case TypeError.authentication:
        return 'La autenticación falló';
      case TypeError.network:
        return 'Error en la conexión a internet';
      case TypeError.interface:
        return 'Error en la aplicación intentelo nuevamente';
      case TypeError.database:
        return 'Error en la base de datos local o remota';
      case TypeError.unknown:
        return 'Error desconocido obtenido en ${error.source}';
    }
    return 'Error desconocido';
  }

  List source = ['API','interface','supabase',''];