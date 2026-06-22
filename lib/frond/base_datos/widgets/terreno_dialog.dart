
import 'package:ecoazuero/backend/llamadas_remotas/llamadas_flora.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widget_form_insert.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'validadores.dart';
import '../../iureutilizables/errores.dart';

class DialogAgregarTerreno extends StatefulWidget {
  const DialogAgregarTerreno({super.key});

  @override
  State<DialogAgregarTerreno> createState() => _DialogAgregarTerrenoState();
}

class _DialogAgregarTerrenoState extends State<DialogAgregarTerreno>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController duenoCtrl = TextEditingController();
  final TextEditingController tamanoCtrl = TextEditingController();
  final TextEditingController coordsCtrl = TextEditingController();
  DateTime? inicioDate;
  late String puntos;

  String construirGeoJSON(String coordsRaw){
    return '''
      {
        "type": "Polygon",
        "coordinates": [$coordsRaw]
      }
    ''';
  }

  void mostrarErrorUI(BuildContext context, OnError error) {
    debugPrint(' ERROR REAL UI: ${error.source} | ${error.type} | ${error.message}',);
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(
          '${error.source}: ${error.message}'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), 
          child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void guardar() async {
    bool result = false;
    try {
      if(! _formKey.currentState!.validate()) throw Exception('falló la validacion');
      if(inicioDate == null || puntos == '') throw Exception('valores fecha o coordenadas vacíos');
    } catch (e) {
      final error = OnError(
        type: 'ui',
        message: e.toString(),
        source: 'siembra',
      );
      if(!mounted) return;
      mostrarErrorUI(context, error);
    }
    final coordsFormateadas = construirGeoJSON(puntos);
    final data = {
      "dueno": duenoCtrl.text.trim(),
      "tamano": double.parse(tamanoCtrl.text),
      "inicio_reforestacion": '${inicioDate!.year}-${inicioDate!.month.toString().padLeft(2,"0")}-${inicioDate!.day.toString().padLeft(2,"0")}',
      "coordenadas": coordsFormateadas,
    };
    try {
      await insertAPI(data, 'insertTerreno', null);
      if(!mounted) return;
      Navigator.pop(context,result);
    } on OnError catch (e) {
      if(context.mounted){
        if(!mounted) return;
        mostrarErrorUI(context, e);
      }
    } catch (e) {
      final error = OnError(
        type: 'ui',
        message: e.toString(),
        source: 'NombrePantalla',
      );
      if(!mounted) return;
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
              const SizedBox(height: Estilos.paddingMedio,),
              TextFormField(
                    controller: tamanoCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('admin.alquiler.tamaño'),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Ingrese el tamaño';
                      }
                      final n = double.tryParse(value);
                      if(n == null){
                        return 'Debe ser un número';
                      }
                      return null;
                      },
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              Text(
                inicioDate != null
                  ? '${inicioDate!.year}-${inicioDate!.month}-${inicioDate!.day}'
                  : 'YYYY-MM-DD',
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await selectDate(context,alquiler: true);

                  setState(() {
                    inicioDate = result ?? result;
                  });
                },
                child: Text(context.tr('admin.alquiler.fechaInicio')),
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final coords = await showDialog<String>(
                      context: context,
                      builder: (_)=> const DibujarTerritorio(),
                    );
                    if(coords != null){
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

class _DibujarTerritorioState extends State<DibujarTerritorio>{
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
            onTap:  (tapPosition, point) {
              setState(() {
                puntos.add(point);
              });
            }
          ),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                 userAgentPackageName: 'com.example.ecoazuero',
              ),
              if(puntos.isNotEmpty)
                PolygonLayer(polygons: [
                  Polygon(
                    points: puntos,
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 3,
                  ),
                ],),
                MarkerLayer(
                  markers:
                      puntos.map((punto){
                        return Marker(
                          point: punto, 
                          width: 20,
                          height: 20,
                          child: const Icon(Icons.location_on, color: Colors.red,),  
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          final poligono = convertirAGeoJSON();
          Navigator.pop(context,poligono);
        }, 
        child: Text(context.tr('buttons.enviar')), 
      ),
      ],
    );
  }
  String convertirAGeoJSON(){
    puntos.add(puntos.first);
    final formato = puntos.map((punto){
      return [punto.longitude, punto.latitude];
    }).toList().toString();
    return formato;
  }
}