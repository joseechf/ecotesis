import 'package:flutter/material.dart';
import 'widget_form_insert.dart';
import '../../estilos.dart';
import 'validadores.dart';
import '../../../backend/llamadas_remotas/llamadas_flora.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../iureutilizables/errores.dart';

class SiembraDialog extends StatefulWidget {
  const SiembraDialog({super.key});

  @override
  State<SiembraDialog> createState() => _SiembraDialogState();
}

class _SiembraDialogState extends State<SiembraDialog> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  DateTime? selectedDate;
  final usuarioCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();
  late String? distrito = 'Chitre';
  List<double>? coordenadas;

void mostrarErrorUI(BuildContext context, OnError error) {
  debugPrint(
    'ERROR REAL UI: ${error.source} | ${error.type} | ${error.status} | ${error.message}',
  );
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(
        '${error.source}: ocurrió un error. Intenta nuevamente.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}

  void guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (coordenadas == null || selectedDate == null) return;
    final siembra = {
      "nombre_cientifico": nombreCtrl.text.trim(),
      "fecha_siembra":
          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, "0")}-${selectedDate!.day.toString().padLeft(2, "0")}',
      "usuario": usuarioCtrl.text.trim(),
      "cantidad": int.tryParse(cantidadCtrl.text),
      "distrito": distrito,
      "coordenadas": coordenadas,
    };

      try {
       await insertAPI(siembra, 'insertSiembra');
      if (!mounted) return;
      Navigator.pop(context);
      } on OnError catch (e) {
        if (context.mounted) {
        if (!mounted) return;
          mostrarErrorUI(context, e);
        }
      } catch (e) {
        final error = OnError(
          type: 'ui',
          message: e.toString(),
          source: 'NombrePantalla',
        );
        if (!mounted) return;
        mostrarErrorUI(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('admin.siembra.titulo')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // nombre científico
              CampoTexto(
                label: context.tr('bdInterfaz.insert.Nlatin'),
                controller: nombreCtrl,
                validator: ValidadorTexto.validaObligatorio,
              ),
              const SizedBox(height: Estilos.paddingMedio),

              // fecha
              Text(
                selectedDate != null
                    ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                    : '---',
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await selectDate(context);

                  setState(() {
                    selectedDate = result ?? result;
                  });
                },
                child: Text(context.tr('buttons.fecha')),
              ),
              const SizedBox(height: Estilos.paddingMedio),

              // usuario
              CampoTexto(
                label: context.tr('admin.siembra.usuario'),
                controller: usuarioCtrl,
                validator: ValidadorTexto.validaObligatorio,
              ),
              const SizedBox(height: Estilos.paddingMedio),

              // usuario
              DropdownButtonFormField<String>(
                initialValue: distrito,
                decoration: const InputDecoration(
                  labelText: 'Distrito',
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                      'Chitre',
                      'Las Minas',
                      'Los Pozos',
                      'Ocu',
                      'Parita',
                      'Pese',
                      'Santa Maria',
                      'Las Tablas',
                      'Guarare',
                      'Los Santos',
                      'Macaracas',
                      'Pedasi',
                      'Pocri',
                      'Tonosi',
                    ].map((distritoItem) {
                      return DropdownMenuItem<String>(
                        value: distritoItem,
                        child: Text(distritoItem),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => distrito = v),
              ),
              const SizedBox(height: Estilos.paddingMedio),
              // cantidad
              TextFormField(
                controller: cantidadCtrl,
                decoration: InputDecoration(
                  labelText: context.tr('admin.siembra.cantidad'),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el tamaño';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Debe ser un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Estilos.paddingMedio),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final coords = await showDialog<List<double>>(
                      context: context,
                      builder: (_) => const SeleccionarUbicacionDialog(),
                    );

                    if (coords != null) {
                      setState(() {
                        coordenadas = coords;
                      });
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: Text(context.tr('admin.siembra.ubicacion')),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('buttons.cancelar')),
        ),
        ElevatedButton(
          onPressed: guardar,
          child: Text(context.tr('buttons.add')),
        ),
      ],
    );
  }
}

class SeleccionarUbicacionDialog extends StatefulWidget {
  const SeleccionarUbicacionDialog({super.key});

  @override
  State<SeleccionarUbicacionDialog> createState() =>
      _SeleccionarUbicacionDialogState();
}

class _SeleccionarUbicacionDialogState
    extends State<SeleccionarUbicacionDialog> {
  LatLng? puntoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('admin.siembra.ubicacion')),
      content: SizedBox(
        width: 400,
        height: 400,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(7.7, -80.4),
            initialZoom: 10,

            onTap: (_, latlng) {
              setState(() {
                puntoSeleccionado = latlng;
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
                    child: const Icon(Icons.location_on, color: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        if (puntoSeleccionado != null)
          Text(
            'Long: ${puntoSeleccionado!.longitude}, Lat: ${puntoSeleccionado!.latitude}',
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed:
              puntoSeleccionado == null
                  ? null
                  : () {
                    Navigator.pop(context, [
                      puntoSeleccionado!.longitude,
                      puntoSeleccionado!.latitude,
                    ]);
                  },
          child: Text(context.tr('buttons.enviar')),
        ),
      ],
    );
  }
}
