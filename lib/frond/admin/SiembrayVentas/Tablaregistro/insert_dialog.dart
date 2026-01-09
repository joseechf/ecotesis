import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../provider/admin_providers.dart';
import '../../model/models.dart';
import '../../../estilos.dart';

Future<RSiembra?> mostrarInsertarRSiembraDialog(BuildContext context) async {
  DateTime? fechaPlantacion;
  String? idUsuario;
  final TextEditingController _idUsuarioCtrl = TextEditingController(
    text: idUsuario ?? '',
  );
  final nuevoRegistro = RSiembra.crear(
    fechaPlantacion: DateTime.now(),
    relacion: [SembrableRegistro.vacio()],
  );

  return await showDialog<RSiembra>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nuevo registro de siembra'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // idusuario opcional
                    TextFormField(
                      controller: _idUsuarioCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ID Usuario (opcional)',
                      ),
                    ),

                    /// FECHA
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text(
                        fechaPlantacion == null
                            ? 'Seleccionar fecha'
                            : '${fechaPlantacion!.day}/${fechaPlantacion!.month}/${fechaPlantacion!.year}',
                      ),
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.now(),
                        );
                        if (fecha != null) {
                          setState(() => fechaPlantacion = fecha);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    /// VECTOR SEMBRABLES
                    campoVectorSembrable(
                      context: context,
                      items: nuevoRegistro.relacion,
                      setState: setState,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (fechaPlantacion == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Seleccione una fecha')),
                      );
                      return;
                    }
                    final idUsuarioFinal =
                        _idUsuarioCtrl.text.isEmpty
                            ? null
                            : _idUsuarioCtrl.text;

                    final registroFinal = RSiembra.crear(
                      idUsuario: idUsuarioFinal,
                      fechaPlantacion: fechaPlantacion!,
                      relacion: nuevoRegistro.relacion,
                    );

                    try {
                      await context.read<RegSiembraProvider>().insertarRegistro(
                        registroFinal,
                      );

                      if (context.mounted) {
                        Navigator.pop(context, registroFinal);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        ),
  );
}

Widget campoVectorSembrable({
  required BuildContext context,
  required List<SembrableRegistro> items,
  required void Function(VoidCallback fn) setState,
}) {
  return Column(
    children: [
      ...items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                /// NOMBRE
                TextFormField(
                  initialValue: item.nombreCientifico,
                  decoration: const InputDecoration(
                    labelText: 'Nombre científico',
                  ),
                  onChanged: (v) {
                    setState(() {
                      items[index] = SembrableRegistro(
                        nombreCientifico: v,
                        cantidadSembrado: item.cantidadSembrado,
                        estado: item.estado,
                        coordenadas: item.coordenadas,
                      );
                    });
                  },
                ),

                const SizedBox(height: 10),

                /// CANTIDAD
                TextFormField(
                  initialValue: item.cantidadSembrado.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad sembrada',
                  ),
                  onChanged: (v) {
                    setState(() {
                      items[index] = SembrableRegistro(
                        nombreCientifico: item.nombreCientifico,
                        cantidadSembrado: int.tryParse(v) ?? 0,
                        estado: item.estado,
                        coordenadas: item.coordenadas,
                      );
                    });
                  },
                ),

                const SizedBox(height: 10),

                /// ESTADO
                TextFormField(
                  initialValue: item.estado,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  onChanged: (v) {
                    setState(() {
                      items[index] = SembrableRegistro(
                        nombreCientifico: item.nombreCientifico,
                        cantidadSembrado: item.cantidadSembrado,
                        estado: v,
                        coordenadas: item.coordenadas,
                      );
                    });
                  },
                ),

                const SizedBox(height: 10),

                /// MAPA
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_location),
                      onPressed: () async {
                        final punto = await _abrirMapa(context);
                        if (punto != null) {
                          setState(() {
                            items[index] = SembrableRegistro(
                              nombreCientifico: item.nombreCientifico,
                              cantidadSembrado: item.cantidadSembrado,
                              estado: item.estado,
                              coordenadas: punto,
                            );
                          });
                        }
                      },
                    ),
                    if (item.coordenadas != null)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),

                const Divider(),

                /// BOTONES
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed:
                          items.length == 1
                              ? null
                              : () => setState(() => items.removeAt(index)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed:
                          () => setState(
                            () => items.add(SembrableRegistro.vacio()),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ],
  );
}

Future<LatLng?> _abrirMapa(BuildContext context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SeleccionarUbicacionPage()),
  );
}

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
            setState(() => puntoSeleccionado = latLng);
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
