//import 'dart:ffi';

import 'item.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'syncservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class menuBD extends StatefulWidget {
  const menuBD({Key? key}) : super(key: key);

  @override
  _Iubasedatos createState() => _Iubasedatos();
}

class _Iubasedatos extends State<menuBD> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Verificacion v = Verificacion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final item = Item(
                  name: nameController.text,
                  description: descriptionController.text,
                );
                String? iduser = await obtenerIDUsuario();
                if (iduser != null) {
                  int acceso = await v.VerificarPermisosCrud(iduser, "nada");
                  if (acceso != 0) {
                    final Syncservice sincronizar = Syncservice(iduser: iduser);
                    await sincronizar.insertarSincronizado(item);
                    nameController.clear();
                    descriptionController.clear();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Dato insertado')));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController credencial =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('introduzca credencial de administrador'),
                          content: TextField(
                            controller: credencial,
                            decoration: InputDecoration(
                              labelText: 'Escribe algo',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                String valor = credencial.text;
                                Navigator.of(context).pop();
                                int acceso = await v.VerificarPermisosCrud(
                                  iduser,
                                  valor,
                                );
                                if (acceso == 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('credencial registrada'),
                                    ),
                                  );
                                }
                              },
                              child: Text('enviar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('cancelar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No esta logueado')),
                  );
                }
              },
              child: Text('insertar datos'),
            ),
          ],
        ),
      ),
    );
  }

  //verificar si hay internet
  Future<int> conectar() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return 1;
    }
    return 0;
  }

  //obtiene el id del usuario logueado
  Future<String?> obtenerIDUsuario() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final subAttribute = attributes.firstWhere(
        (attr) => attr.userAttributeKey == CognitoUserAttributeKey.sub,
      );

      return subAttribute.value;
    } catch (e) {
      print('Error obteniendo el sub: $e');
      return null;
    }
  }
}

// verifica que el usuario tenga permiso de CRUD
class Verificacion {
  static const String apiUrl =
      'https://ol8p1je4a1.execute-api.us-east-1.amazonaws.com/verificar';
  Future<int> VerificarPermisosCrud(String iduser, String credencial) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'iduser': iduser, 'credencial': credencial}),
      );
      if (response.statusCode == 200) {
        final respuesta = jsonDecode(response.body);
        if (respuesta['credencial'] == 1) {
          return 1;
        } else {
          return 0;
        }
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }
}
