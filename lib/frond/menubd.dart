//import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:ecoazuero/frond/iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../backend/utilidades/modeloplanta.dart';
import '../backend/CRUDFLORA/updatedatos.dart';
//import '../backend/CRUDFLORA/insertdatos.dart';

class menuBD extends StatefulWidget {
  const menuBD({Key? key}) : super(key: key);

  @override
  _Iubasedatos createState() => _Iubasedatos();
}

class _Iubasedatos extends State<menuBD> {
  final Verificacion _v = Verificacion();
  final TextEditingController nombre = TextEditingController();
  final TextEditingController tipo = TextEditingController();
  final TextEditingController cientifico = TextEditingController();

  List<Map<String, dynamic>> _lista = [];
  Map<String, String?> _filtro = {};
  final List<Modeloplanta> filas = [
    Modeloplanta(
      id: '1',
      nombre: 'calabazo',
      tipo: 'Medicinal',
      cientifico: 'Crescentia cujete',
      imagen: 'assets/images/calabazo.jpeg',
      ultAct: '1',
    ),
    Modeloplanta(
      id: '2',
      nombre: 'caucho',
      tipo: 'Medicinal',
      cientifico: 'Castilla elastica',
      imagen: 'assets/images/castilla.jpeg',
      ultAct: '1',
    ),
    Modeloplanta(
      id: '3',
      nombre: 'yuco de monte',
      tipo: 'fruta',
      cientifico: 'Pachira sessilis',
      imagen: 'assets/images/yuco.jpeg',
      ultAct: '1',
    ),
    Modeloplanta(
      id: '4',
      nombre: 'orinea',
      tipo: 'Medicinal',
      cientifico: 'Warszewiczia coccinea',
      imagen: 'assets/images/flor.jpeg',
      ultAct: '1',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _cargarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity, // Ocupa todo el ancho disponible
            constraints: BoxConstraints(maxHeight: 50),
            color: Colors.green[100],
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    String? iduser = await _obtenerIdUsuario();
                    if (iduser != null) {
                      int acceso = await _v.VerificarPermisosCrud(
                        iduser,
                        "nada",
                      );
                      if (acceso != 0) {
                        /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => insertBD(),
                                  ),
                                );*/
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController credencial =
                                TextEditingController();
                            return AlertDialog(
                              title: Text(
                                'introduzca credencial de administrador',
                              ),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'credencial registrada',
                                          ),
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
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _InterfazFiltro(context);
                  },
                  child: Text(context.tr('buttons.filtrar')),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          //conteniedo de la base de datos
          Expanded(
            child:
                _lista.isNotEmpty
                    ? SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(_lista.length, (index) {
                              return Container(
                                width: 300,
                                height: 600,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(
                                        0,
                                        4,
                                      ), // sombra hacia abajo
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    WidgetPersonalizados.ListaWidgetOrdenada(
                                      _lista[index],
                                      20,
                                      context,
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => interfazUpDatos(
                                                  lista: _lista[index],
                                                ),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(context.tr('buttons.editar')),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    )
                    : Center(child: Text('No hay datos')),
          ),
        ],
      ),
    );
  }

  void _cargarLista() async {
    //este if va a cambiar al utilizar un select, pero de momento uso esto
    if (!_filtro.isEmpty) {
      _lista.clear();
      for (int index = 0; index < filas.length; index++) {
        if ((filas[index].nombre.toString() == _filtro['nombre']) ||
            (_filtro['nombre'] == null)) {
          if ((filas[index].tipo.toString() == _filtro['tipo']) ||
              (_filtro['tipo'] == null)) {
            if ((filas[index].cientifico.toString() == _filtro['cientifico']) ||
                (_filtro['cientifico'] == null)) {
              _lista.add(filas[index].toMap());
            }
          }
        }
      }
    } else {
      _lista = List.generate(filas.length, (index) {
        return filas[index].toMap();
      });
    }
    setState(() {
      () {};
    });
  }

  //verificar si hay internet
  Future<int> conectar() async {
    final resultados =
        await Connectivity().checkConnectivity(); // List<ConnectivityResult>

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

  void _InterfazFiltro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombre,
                decoration: InputDecoration(labelText: 'nombre'),
              ),
              TextField(
                controller: tipo,
                decoration: InputDecoration(labelText: 'tipo'),
              ),
              TextField(
                controller: cientifico,
                decoration: InputDecoration(labelText: 'cientifico'),
              ),
              ElevatedButton(
                onPressed: () {
                  String _nombre = nombre.text.trim();
                  String _tipo = tipo.text.trim();
                  String _cientifico = cientifico.text.trim();
                  setState(() {
                    _filtro = {
                      'nombre': _nombre.isEmpty ? null : _nombre,
                      'tipo': _tipo.isEmpty ? null : _tipo,
                      'cientifico': _cientifico.isEmpty ? null : _cientifico,
                    };
                    _cargarLista();
                  });
                },
                child: Text('aplicar filtros'),
              ),
            ],
          ),
        );
      },
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
