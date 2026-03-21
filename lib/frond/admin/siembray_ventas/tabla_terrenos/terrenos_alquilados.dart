/*
import 'package:flutter/material.dart';
import '../../model/models.dart';
import '../../provider/ejemplo.dart';
import 'package:ecoazuero/frond/estilos.dart';
import '../widget_reutilizables.dart';
import 'package:flutter/gestures.dart';

class RentedLand extends StatefulWidget {
  const RentedLand({super.key});

  @override
  State<RentedLand> createState() => _RentedLandState();
}

class _RentedLandState extends State<RentedLand> {
  final _form = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();

  void _addRecord() {
    final caracterizacion = _form['Caracterizacion'] as String? ?? '';
    final fechaInicio = _form['FechaInicio'] as String? ?? '';
    final fechaFinal = _form['FechaFinal'] as String? ?? '';
    final direccion = _form['Direccion'] as String? ?? '';
    final tamanio = _form['Tamanio'] as String? ?? '';

    if (caracterizacion.isEmpty ||
        fechaInicio.isEmpty ||
        fechaFinal.isEmpty ||
        direccion.isEmpty ||
        tamanio.isEmpty) {
      return;
    }

    setState(() {
      terrenos.add(
        TerrenosAlquilados(
          idAlquiler: '1',
          idUsuario: '1',
          fechaInicio: fechaInicio,
          fechaFinal: fechaFinal,
          direccion: direccion,
          tamanio: tamanio,
          caracterizacion: caracterizacion,
          estado: 'en alquiler',
        ),
      );
    });
    _form.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Registrar Terreno'),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'caracterizacion',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved:
                                        (v) => _form['caracterizacion'] = v,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Fecha Inicio',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved: (v) => _form['fechaInicio'] = v,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Fecha Fin',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved: (v) => _form['fechaFinal'] = v,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'direccion',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved: (v) => _form['direccion'] = v,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Tamaño',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved: (v) => _form['tamanio'] = v,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _addRecord();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Agregar'),
                            ),
                          ],
                        ),
                  ),
              icon: const Icon(Icons.add, color: Estilos.blanco),
              label: const Text(
                'Insert',
                style: TextStyle(color: Estilos.blanco),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Estilos.verdePrincipal,
                ),
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.all(Estilos.paddingMedio),
                    decoration: BoxDecoration(
                      color: Estilos.blanco, // fondo de la tabla
                      borderRadius: BorderRadius.circular(
                        Estilos.radioBordeGrande, // bordes redondeados
                      ),
                      boxShadow:
                          Estilos
                              .sombraSuave, // sombra suave del archivo estilos.dart
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Estilos.grisClaro, // color de encabezado
                      ),
                      dataRowColor: WidgetStateProperty.all(
                        Estilos.blanco, // color de filas normales
                      ),
                      columnSpacing: 24,
                      headingRowHeight: 48,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 64,
                      columns: [
                        dataColumn('idAlquiler'),
                        dataColumn('idUsuario'),
                        dataColumn('fechaInicio'),
                        dataColumn('direccion'),
                        dataColumn('tamanio'),
                        dataColumn('acciones'),
                      ],
                      rows:
                          terrenos.map((row) {
                            return DataRow(
                              cells: [
                                DataCell(Text(row.idAlquiler)),
                                DataCell(Text(row.idUsuario)),
                                DataCell(Text(row.fechaInicio)),
                                DataCell(Text(row.direccion)),
                                DataCell(Text(row.tamanio)),
                                DataCell(menuUpdateDelete(row)),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuUpdateDelete(row) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 30, // ancho del menú
      ),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'edit') {
          () => setState(() => {});
        } else if (value == 'delete') {
          () => setState(() => terrenos.remove(row));
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [Icon(Icons.edit, size: 18)]),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [Icon(Icons.delete, color: Colors.red, size: 18)],
              ),
            ),
          ],
    );
  }
}
*/
