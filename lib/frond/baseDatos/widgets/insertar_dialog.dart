import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';

Future<Especie?> mostrarInsertarDialog(BuildContext context) async {
  final NombreLatin = TextEditingController();
  final nombreCtrl = TextEditingController();
  final ubicacionCtrl = TextEditingController();
  final polinizadorCtrl = TextEditingController();
  String establecidoa = 'Mixto';

  return await showDialog<Especie>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
              ),
              title: Text(
                context.tr('bdInterfaz.nuevaEspecie'),
                style: TextStyle(
                  color: Estilos.verdeOscuro,
                  fontSize: Estilos.textoMedio,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: NombreLatin,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Nlatin'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nombreCtrl,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Ncomun'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: establecidoa,
                      items:
                          [
                                'Establecido al sol',
                                'Establecido a la sombra',
                                'Mixto',
                              ]
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => establecidoa = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.establecido'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: ubicacionCtrl,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.ubicacion'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: polinizadorCtrl,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Polinizador'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr('buttons.cancelar')),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      Especie(
                        nombreLatino: '',
                        nombre: NombreLatin.text,
                        imagen: nombreCtrl.text,
                        establecido: establecidoa,
                        ubicacion: ubicacionCtrl.text,
                        polinizador: polinizadorCtrl.text,
                      ),
                    );
                  },
                  child: Text(context.tr('buttons.add')),
                ),
              ],
            );
          },
        ),
  );
}
