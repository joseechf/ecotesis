import 'package:flutter/material.dart';
import '../../../backend/llamadas_remotas/llamadas_flora.dart';
import 'widget_form_insert.dart';
import '../../estilos.dart';
import 'validadores.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../iureutilizables/errores.dart';

class DialogoAgregarTerreno extends StatefulWidget {
  const DialogoAgregarTerreno({super.key});

  @override
  State<DialogoAgregarTerreno> createState() => _DialogoAgregarTerrenoState();
}

class _DialogoAgregarTerrenoState extends State<DialogoAgregarTerreno> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController duenoCtrl = TextEditingController();
  final TextEditingController tamanoCtrl = TextEditingController();
  final TextEditingController coordsCtrl = TextEditingController();
  DateTime? inicioDate;
  DateTime? finDate;

  late String puntos;

  String construirGeoJSON(String coordsRaw) {
    return '''
    {
      "type": "Polygon",
      "coordinates": 
        [$coordsRaw]
    }
    ''';
  }

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
    if (puntos == '') return;
    if (inicioDate == null || finDate == null) return;
    if (!_formKey.currentState!.validate()) return;
    final coordsFormateadas = construirGeoJSON(puntos);
    debugPrint(coordsFormateadas);
    final data = {
      'dueno': duenoCtrl.text.trim(),
      'tamano': int.parse(tamanoCtrl.text),
      'inicio_alquiler':
          '${inicioDate!.year}-${inicioDate!.month.toString().padLeft(2, "0")}-${inicioDate!.day.toString().padLeft(2, "0")}',
      'fin_alquiler':
          '${finDate!.year}-${finDate!.month.toString().padLeft(2, "0")}-${finDate!.day.toString().padLeft(2, "0")}',
      'coordenadas': coordsFormateadas,
    };

        try {
      await insertAPI(data, 'insertTerreno');
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
      title: Text(context.tr('admin.alquiler.titulo')),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoTexto(
                label: context.tr('admin.alquiler.dueño'),
                controller: duenoCtrl,
                validator: ValidadorTexto.validaObligatorio,
              ),
              const SizedBox(height: Estilos.paddingMedio),

              TextFormField(
                controller: tamanoCtrl,
                decoration: InputDecoration(
                  labelText: context.tr('admin.alquiler.tamaño'),
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
              // Inicio alquiler
              Text(
                inicioDate != null
                    ? '${inicioDate!.year}-${inicioDate!.month}-${inicioDate!.day}'
                    : 'No date selected',
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await selectDate(context, alquiler: true);

                  setState(() {
                    inicioDate = result ?? result;
                  });
                },
                child: Text(context.tr('admin.alquiler.fechaInicio')),
              ),
              const SizedBox(height: Estilos.paddingMedio),

              // Fin alquiler
              Text(
                finDate != null
                    ? '${finDate!.year}-${finDate!.month}-${finDate!.day}'
                    : '---',
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await selectDate(context, alquiler: true);

                  setState(() {
                    finDate = result ?? result;
                  });
                },
                child: Text(context.tr('admin.alquiler.fechaFinal')),
              ),
              const SizedBox(height: 10),
              /*BotonPersonalizado(
                texto: context.tr('admin.siembra.ubicacion'),
                icono: const Icon(Icons.map),
                onPressed: () async {
                  final coords = await showDialog<String>(
                    context: context,
                    builder: (_) => const DibujarTerritorio(),
                  );

                  if (coords != null) {
                    setState(() {
                      puntos = coords;
                    });
                  }
                },
              ),*/
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final coords = await showDialog<String>(
                      context: context,
                      builder: (_) => const DibujarTerritorio(),
                    );

                    if (coords != null) {
                      setState(() {
                        puntos = coords;
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

class DibujarTerritorio extends StatefulWidget {
  const DibujarTerritorio({super.key});

  @override
  State<DibujarTerritorio> createState() => _DibujarTerritorioState();
}

class _DibujarTerritorioState extends State<DibujarTerritorio> {
  List<LatLng> puntos = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 400,
        height: 400,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(7.96, -80.42),
            initialZoom: 14,
            onTap: (tapPosition, point) {
              setState(() {
                puntos.add(point);
              });
            },
          ),

          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            if (puntos.isNotEmpty)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: puntos,
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 3,
                  ),
                ],
              ),

            MarkerLayer(
              markers:
                  puntos.map((punto) {
                    return Marker(
                      point: punto,
                      width: 20,
                      height: 20,
                      child: const Icon(Icons.location_on, color: Colors.red),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final poligono = convertirAGeoJson();
            Navigator.pop(context, poligono);
          },
          child: Text(context.tr('buttons.enviar')),
        ),
      ],
    );
  }

  // Convierte puntos a GeoJSON
  String convertirAGeoJson() {
    //cerrar el poligono
    puntos.add(puntos.first);
    final formato =
        puntos
            .map((punto) {
              return [punto.longitude, punto.latitude];
            })
            .toList()
            .toString();
    return formato;
  }
}
