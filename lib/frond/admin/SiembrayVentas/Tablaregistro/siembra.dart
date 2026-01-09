import 'package:ecoazuero/frond/admin/SiembrayVentas/widgetReutilizables.dart';
import 'package:flutter/material.dart';
import '../../model/models.dart';
import 'package:ecoazuero/frond/estilos.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../provider/admin_providers.dart';
import 'insert_dialog.dart';

class RentalRecords extends StatefulWidget {
  const RentalRecords({super.key});

  @override
  State<RentalRecords> createState() => _RentalRecordsState();
}

class _RentalRecordsState extends State<RentalRecords> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegSiembraProvider>().cargarRegSiembra();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegSiembraProvider>();

    if (provider.cargandoData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 5),

          /// BOTÓN INSERTAR
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Estilos.blanco),
              label: const Text(
                'Insertar siembra',
                style: TextStyle(
                  color: Estilos.blanco,
                  fontFamily: Estilos.tipografia,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Estilos.verdePrincipal,
                ),
              ),
              onPressed: () async {
                final nuevo = await mostrarInsertarRSiembraDialog(context);

                if (nuevo != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro de siembra guardado'),
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          /// TABLA RESPONSIVA (SOLO SCROLL HORIZONTAL)
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(Estilos.paddingMedio),
                  decoration: BoxDecoration(
                    color: Estilos.blanco,
                    borderRadius: BorderRadius.circular(
                      Estilos.radioBordeGrande,
                    ),
                    boxShadow: Estilos.sombraSuave,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Estilos.grisClaro),
                    dataRowColor: WidgetStateProperty.all(Estilos.blanco),
                    //columnSpacing: 24,
                    dataRowMinHeight: 60, // altura mínima
                    dataRowMaxHeight: double.infinity, // permite crecer

                    columns: [
                      dataColumn('idRegistro'),
                      dataColumn('Usuario'),
                      dataColumn('Fecha'),
                      dataColumn('Plantas (Cantidad × Especie × Estado)'),
                      dataColumn('Acciones'),
                    ],

                    rows:
                        provider.rsiembra.map((row) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  row.idRegistro ?? '-',
                                  style: const TextStyle(
                                    fontFamily: Estilos.tipografia,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  row.nombreUsuario ?? '-',
                                  style: const TextStyle(
                                    fontFamily: Estilos.tipografia,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${row.fechaPlantacion.day}/${row.fechaPlantacion.month}/${row.fechaPlantacion.year}',
                                  style: const TextStyle(
                                    fontFamily: Estilos.tipografia,
                                  ),
                                ),
                              ),

                              /// COLUMNA VECTOR ESTABLE
                              DataCell(vectorCantidadEstado(row.relacion)),

                              DataCell(MenuUpdateDelete(row)),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vectorCantidadEstado(List<SembrableRegistro> relacion) {
    if (relacion.isEmpty) {
      return const Text('-');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          relacion.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Estilos.verdeClaro,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${e.cantidadSembrado}',
                      style: const TextStyle(color: Estilos.verdeOscuro),
                    ),
                    const Text(
                      ' × ',
                      style: TextStyle(color: Estilos.verdeOscuro),
                    ),
                    Text(
                      e.nombreCientifico,
                      style: const TextStyle(
                        color: Estilos.verdeOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ' × ',
                      style: TextStyle(color: Estilos.verdeOscuro),
                    ),
                    Text(
                      e.estado,
                      style: const TextStyle(color: Estilos.verdeOscuro),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget MenuUpdateDelete(RSiembra row) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'edit') {
          // abrir diálogo
        } else if (value == 'delete') {
          context.read<RegSiembraProvider>().eliminarRegistro(row);
        }
      },
      itemBuilder:
          (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
            ),
          ],
    );
  }

  Future<LatLng?> _abrirMapa(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SeleccionarUbicacionPage()),
    );
  }
}

// pantalla del mapa

class SeleccionarUbicacionPage extends StatefulWidget {
  const SeleccionarUbicacionPage({super.key});

  @override
  State<SeleccionarUbicacionPage> createState() =>
      _SeleccionarUbicacionPageState();
}

class _SeleccionarUbicacionPageState extends State<SeleccionarUbicacionPage> {
  LatLng? puntoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar ubicación'),
        actions: [
          TextButton(
            onPressed:
                puntoSeleccionado == null
                    ? null
                    : () => Navigator.pop(context, puntoSeleccionado),
            child: const Text(
              'CONFIRMAR',
              style: TextStyle(color: Estilos.blanco),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(40.4168, -3.7038),
          initialZoom: 12,
          onTap: (_, latLng) {
            setState(() {
              puntoSeleccionado = latLng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          if (puntoSeleccionado != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: puntoSeleccionado!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.place, color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
