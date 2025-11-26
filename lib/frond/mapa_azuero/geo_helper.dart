import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

Future<Map<String, List<dynamic>>> loadGeoJson(
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
            child: Icon(Icons.local_library, size: 32, color: color),
          ),
        );
        break;
    }
  }
  return {'polygons': polygons, 'polylines': polylines, 'markers': markers};
}
