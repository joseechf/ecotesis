import 'package:flutter/material.dart';
import '../provider/bdFake/models.dart';
import '../provider/ejemplo.dart';
import 'package:ecoazuero/frond/estilos.dart';
import '../widgetReutilizables.dart';
import 'package:flutter/gestures.dart';

class rentedLand extends StatefulWidget {
  const rentedLand({super.key});

  @override
  State<rentedLand> createState() => _rentedLandState();
}

class _rentedLandState extends State<rentedLand> {
  final _form = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();

  void _addRecord() {
    final Caracterizacion = _form['Caracterizacion'] as String? ?? '';
    final FechaInicio = _form['FechaInicio'] as String? ?? '';
    final FechaFinal = _form['FechaFinal'] as String? ?? '';
    final Direccion = _form['Direccion'] as String? ?? '';
    final Tamanio = _form['Tamanio'] as String? ?? '';

    if (Caracterizacion.isEmpty ||
        FechaInicio.isEmpty ||
        FechaFinal.isEmpty ||
        Direccion.isEmpty ||
        Tamanio.isEmpty)
      return;

    setState(() {
      terrenos.add(
        terrenosAlquilados(
          idAlquiler: '1',
          idUsuario: '1',
          fechaInicio: FechaInicio,
          fechaFinal: FechaFinal,
          direccion: Direccion,
          tamanio: Tamanio,
          caracterizacion: Caracterizacion,
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
                                      labelText: 'Caracterizacion',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved:
                                        (v) => _form['Caracterizacion'] = v,
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
                                    onSaved: (v) => _form['FechaInicio'] = v,
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
                                    onSaved: (v) => _form['FechaFinal'] = v,
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Direccion',
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'no puede estar vacio';
                                      }
                                      return null;
                                    },
                                    onSaved: (v) => _form['Direccion'] = v,
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
                                    onSaved: (v) => _form['Tamanio'] = v,
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
              // ← CENTRA TODO EN PANTALLA
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
                                DataCell(MenuUpdateDelete(row)),
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

  Widget MenuUpdateDelete(row) {
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
