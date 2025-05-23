//import 'dart:ffi';

import 'package:ecoazuero/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../backend/CRUDFLORA/insertdatos.dart';
import '../backend/detectaplataforma.dart';
import '../backend/utilidades/item.dart';

class menuBD extends StatefulWidget {
  const menuBD({Key? key}) : super(key: key);

  @override
  _Iubasedatos createState() => _Iubasedatos();
}

class _Iubasedatos extends State<menuBD> {
  final Verificacion _v = Verificacion();
  final crud _crudWebMobil = crud();
  List<Map<String,dynamic>> _lista = [];
  @override
  void initState(){
    super.initState();
    _cargarLista();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity, // Ocupa todo el ancho disponible
              constraints: BoxConstraints(maxHeight: 50),
              color: Colors.green[100],
              alignment: Alignment.center,
              child: ElevatedButton(
              onPressed: () async {
                String? iduser = await _obtenerIdUsuario();
                if (iduser != null) {
                  int acceso = await _v.VerificarPermisosCrud(iduser, "nada");
                  if (acceso != 0) {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => insertBD(),
                                  ),
                                );
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
                                int acceso = await _v.VerificarPermisosCrud(
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
                    const SnackBar(content: Text('DEBE INICIAR SESION')),
                  );
                }
              },
              child: Text('insertar datos'),
            ),
            ),
            //conteniedo de la base de datos
            LayoutBuilder(
              builder: (context, constraints) {
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(_lista.length, (index){
                      return Container(
                        width: 300,
                        height: 700,
                        color: Colors.amber,
                        child: _ordenarCampos(_lista[index]),
                      );
                    })
                  );
              },
            ),
          ],
        ),
      ),),
    );
  
  }

  void _cargarLista() async {
    final online = await conectar();
    if(online == 1){
      _lista = await _crudWebMobil.leerDatos();
    }else{
      _lista = [{'nombre': 'arbol1','tipo': 'madera'},{'nombre': 'arbol2','tipo':'fruta'}];
    }
      setState(() {
        (){};
      });
  }

  //verificar si hay internet
  Future<int> conectar() async {
    final resultados = await Connectivity().checkConnectivity(); // List<ConnectivityResult>

    if (resultados.contains(ConnectivityResult.none) || resultados.isEmpty) {
      return 0; // Sin conexión
    } else {
      return 1; // Hay alguna conexión
    }
  }
  //obtiene el id del usuario logueado
  Future<String?> _obtenerIdUsuario() async {
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

  Widget _ordenarCampos(Map<String,dynamic> registro){
    return Column(
      children: registro.entries.map<Widget>((entry) {
        if (entry.key == 'imagen') {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Image.network(
              entry.value,               
              width: 100,                
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text('${entry.key}: ${entry.value}'),
        );
      }).toList(),
    );
  }

}

// verifica que el usuario tenga permiso de CRUD
class Verificacion {
  static const String _apiUrl =
      'https://t3f65fc1ta.execute-api.us-east-1.amazonaws.com/verificar';
  Future<int> VerificarPermisosCrud(String iduser, String credencial) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
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
