import 'package:ecoazuero/frond/admin/SiembrayVentas/widgetReutilizables.dart';
import 'package:flutter/material.dart';
import '../provider/bdFake/models.dart';
import '../provider/ejemplo.dart';
import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/gestures.dart';

class RentalRecords extends StatefulWidget {
  const RentalRecords({super.key});

  @override
  State<RentalRecords> createState() => _RentalRecordsState();
}

class _RentalRecordsState extends State<RentalRecords> {
  //final List<RSiembra> _sembrados = [];

  final _form = <String, dynamic>{};

  void _addRecord() {
    final especie = _form['especie'] as String? ?? '';
    final start = _form['start'] as String? ?? '';
    final end = _form['end'] as String? ?? '';
    final coordenadas = _form['coordenadas'] as String? ?? '';

    if (especie.isEmpty || start.isEmpty || end.isEmpty || coordenadas.isEmpty)
      return;

    setState(() {
      sembrados.add(
        RSiembra(
          idRegistro: DateTime.now().millisecondsSinceEpoch.toString(),
          idSiembra: '2',
          nombreLatino: especie,
          idUsuario: '1',
          nombreUsuario: 'juan',
          fechaPlantacion: start,
          fechaBrote: end,
          cantidad: 1,
          coordenadas: coordenadas,
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
                          title: const Text('Registrar Siembra'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Latino',
                                ),
                                onChanged: (v) => _form['especie'] = v,
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Fecha Inicio',
                                ),
                                onChanged: (v) => _form['start'] = v,
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Fecha Fin',
                                ),
                                onChanged: (v) => _form['end'] = v,
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Coordenadas JSON',
                                ),
                                onChanged: (v) => _form['coordenadas'] = v,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: _addRecord,
                              child: const Text('Registrar'),
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
                        dataColumn('idRegistro'),
                        dataColumn('idSiembra'),
                        dataColumn('nombreLatino'),
                        dataColumn('idUsuario'),
                        dataColumn('nombreUsuario'),
                        dataColumn('fechaPlantacion'),
                        dataColumn('fechaBrote'),
                        dataColumn('cantidad'),
                        dataColumn('coordenadas'),
                        dataColumn('acciones'),
                      ],
                      rows:
                          sembrados.map((row) {
                            return DataRow(
                              cells: [
                                DataCell(Text(row.idRegistro)),
                                DataCell(Text(row.idSiembra)),
                                DataCell(Text(row.nombreLatino)),
                                DataCell(Text(row.idUsuario)),
                                DataCell(Text(row.nombreUsuario)),
                                DataCell(Text(row.fechaPlantacion)),
                                DataCell(Text(row.fechaBrote)),
                                DataCell(Text(row.cantidad.toString())),
                                DataCell(Text(row.coordenadas)),
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
