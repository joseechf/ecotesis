import 'package:flutter/material.dart';
import '../../model/models.dart';
import 'package:ecoazuero/frond/estilos.dart';
import '../../provider/ejemplo.dart';
import 'package:flutter/gestures.dart';
import '../widgetReutilizables.dart';

class SalesInventory extends StatefulWidget {
  const SalesInventory({super.key});

  @override
  State<SalesInventory> createState() => _SalesInventoryState();
}

class _SalesInventoryState extends State<SalesInventory> {
  final _form = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();

  void _addProduct() {
    final name = _form['name'] as String? ?? '';
    final cantidad = int.tryParse(_form['cantidad'].toString()) ?? 0;
    final forma = _form['forma'] as String? ?? '';

    if (name.isEmpty || cantidad <= 0 || forma.isEmpty) return;

    setState(() {
      paraVenta.add(
        Vendibles(
          idVendible: DateTime.now().millisecondsSinceEpoch.toString(),
          nombreLatino: name,
          cantDisponible: cantidad,
          forma: forma,
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
                          title: const Text('Agregar Especies para Venta'),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre Latino',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'no puede estar vacio';
                                    }
                                    return null;
                                  },
                                  onSaved: (v) => _form['nombreLatin'] = v,
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Cantidad',
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'La cantidad es obligatoria';
                                    }
                                    final numero = int.tryParse(v);
                                    if (numero == null || numero <= 0) {
                                      return 'Ingrese una cantidad valida';
                                    }
                                    return null;
                                  },
                                  onSaved:
                                      (v) => _form['cantidad'] = int.parse(v!),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Forma',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'no puede estar vacio';
                                    }
                                    return null;
                                  },
                                  onSaved: (v) => _form['forma'] = v,
                                ),
                              ],
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
                                  _addProduct();
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
                        dataColumn('idVendible'),
                        dataColumn('nombreLatino'),
                        dataColumn('cantDisponible'),
                        dataColumn('forma'),
                        dataColumn('acciones'),
                      ],
                      rows:
                          paraVenta.map((row) {
                            return DataRow(
                              cells: [
                                DataCell(Text(row.idVendible)),
                                DataCell(Text(row.nombreLatino)),
                                DataCell(Text(row.cantDisponible.toString())),
                                DataCell(Text(row.forma)),
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
