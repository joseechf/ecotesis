import 'dart:convert';
import 'package:ecoazuero/frond/admin/SiembrayVentas/provider/bdFake/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../estilos.dart';

import '../admin/SiembrayVentas/provider/ejemplo.dart';

Future<Map<String, List<dynamic>>> loadGeoJson(
  BuildContext context,
  String path, {
  Color color = Colors.blue,
}) async {
  final str = await rootBundle.loadString(path);
  final data = jsonDecode(str);

  final polygons = <Polygon>[]; //lista para poligonos
  final polylines = <Polyline>[]; //lista para lineas
  final markers = <Marker>[]; //lista para puntos

  LatLng toLatLng(dynamic coord) => LatLng(
    (coord[1] as num).toDouble(),
    (coord[0] as num).toDouble(),
  ); //formato de geojson [lon,lat] a flutter_map [lat,lon]

  for (final feature in data['features']) {
    final geom = feature['geometry'];
    final properties = feature['properties'];
    switch (geom['type']) {
      case 'Polygon':
        for (final ring in geom['coordinates']) {
          polygons.add(
            Polygon(
              points: ring.map<LatLng>(toLatLng).toList(),
              color: color.withOpacity(0.3),
              borderColor: color,
              borderStrokeWidth: 2,
            ),
          );
        }
        break;
      case 'LineString':
        polylines.add(
          Polyline(
            points: geom['coordinates'].map<LatLng>(toLatLng).toList(),
            strokeWidth: 3,
            color: color,
          ),
        );
        break;
      case 'Point':
        markers.add(
          Marker(
            point: toLatLng(geom['coordinates']),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                RSiembra siembra = sembrados.firstWhere(
                  (item) => item.idRegistro == properties['name'],
                );
                print(siembra);
                mostrarTarjetaPoint(context, siembra);
              },
              child: Icon(Icons.local_library, size: 32, color: color),
            ),
          ),
        );
        break;
    }
  }

  return {'polygons': polygons, 'polylines': polylines, 'markers': markers};
}

void mostrarTarjetaPoint(BuildContext context, RSiembra siembra) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          //modificar forma de tarjeta
          borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
        ),
        title: Text(siembra.idSiembra),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Estilos.paddingMedio),
              _fila(Icons.label, 'nombre especie', siembra.nombreLatino),
              _fila(
                Icons.access_time_outlined,
                'Fecha de inicio',
                siembra.fechaPlantacion,
              ),
              _fila(
                Icons.calendar_month_outlined,
                'Fecha de brote',
                siembra.fechaBrote,
              ),
              _fila(Icons.numbers, 'Cantidad', siembra.cantidad),
            ],
          ),
        ),
      );
    },
  );
}

Widget _fila(IconData icono, String titulo, dynamic valor) {
  final String valorFormateado = (valor is String) ? valor : valor.toString();
  return Padding(
    padding: const EdgeInsets.only(bottom: Estilos.paddingPequeno),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 20, color: Estilos.verdeOscuro),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: Estilos.textoPequeno,
                  color: Estilos.verdeOscuro,
                ),
              ),
              Text(
                valorFormateado,
                style: const TextStyle(fontSize: Estilos.textoGrande),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
