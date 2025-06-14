import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../frond/iureutilizables/widgetpersonalizados.dart';
import '../../frond/menubd.dart';

//class interfazUpDatos extends StatelessWidget {
class interfazUpDatos extends StatefulWidget {
  final Map lista;
  const interfazUpDatos({Key? key, required this.lista}) : super(key: key);

  @override
  _interfazUpDatos createState() => _interfazUpDatos();
}

class _interfazUpDatos extends State<interfazUpDatos> {
    
    final TextEditingController nombre = TextEditingController(
      text: 'nombre',
    );
    final TextEditingController cientifico = TextEditingController(
      text: 'cientifico',
    );
    final List<String> opcionesTipo = ["Medicinal", "Frutal", "Maderable"];
    final _formKey = GlobalKey<FormState>();
  String? tipo;
  @override
  Widget build(BuildContext context) {
    final Map lista = widget.lista;
    if(nombre.text == 'nombre'){
      nombre.text = lista['nombre'].toString();
    }
    if(cientifico.text == 'cientifico'){
      cientifico.text = lista['cientifico'].toString();
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
            alignment: Alignment.center,
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
                  offset: Offset(0, 4), // sombra hacia abajo
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: nombre,
                        decoration: InputDecoration(labelText: context.tr('Login.name')),
                        validator: (nombre) {
                          if ((!RegExp(r'^[a-zA-Z- ]+$').hasMatch(nombre!)) &&
                              (nombre.isNotEmpty)) {
                            return context.tr('nonumero');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 5,
                        runSpacing: 8,
                        children:
                            opcionesTipo.map((opcion) {
                              return ChoiceChip(
                                label: Text(opcion),
                                selected: tipo == opcion,
                                selectedColor: const Color.fromARGB(255, 104, 202, 109),
                                shape: RoundedRectangleBorder(
                                  // forma del chip
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                    color: const Color.fromARGB(144, 5, 59, 17),
                                  ),
                                ),
                                onSelected: (bool seleccionado) {
                                  setState(() {
                                    tipo = opcion;
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: cientifico,
                        decoration: InputDecoration(labelText: context.tr('buttons.nameC')),
                        validator: (cientifico) {
                          if ((!RegExp(
                                r'^[a-zA-Z- ]+$',
                              ).hasMatch(cientifico!)) &&
                              (cientifico.isNotEmpty)) {
                            return context.tr('nonumero');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                WidgetPersonalizados.constructorContainerimg(
                  lista['imagen'].toString(),
                  0,
                  0,
                  250,
                  20
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('DATOS ACTUALIZADOS')),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => menuBD()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(context.tr('buttons.update')),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }
}
