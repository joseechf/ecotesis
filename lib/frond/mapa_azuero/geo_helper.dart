import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class GeoData {
  final List<Polygon> polygons;
  final List<Polyline> polylines;
  final List<Marker> markers;
  final List<PolygonTapData> polygonTaps;

  GeoData({
    required this.polygons,
    required this.polylines,
    required this.markers,
    required this.polygonTaps,
  });
}

class PolygonTapData {
  final Polygon polygon;
  final LatLng center;
  final Map<String, dynamic> properties;

  PolygonTapData({
    required this.polygon,
    required this.center,
    required this.properties,
  });
}

Future<GeoData> loadGeoJson(
  String path, {
  Color color = Colors.blue,
  void Function(LatLng, Map<String, dynamic>)? onMarkerTap,
  void Function(LatLng, Map<String, dynamic>)? onPolygonTap,
}) async {
  final raw = await rootBundle.loadString(path);
  final data = json.decode(raw) as Map<String, dynamic>;

  final polygons = <Polygon>[];
  final polylines = <Polyline>[];
  final markers = <Marker>[];
  final polygonTaps = <PolygonTapData>[];

  // GeoJSON [lon, lat] -> flutter_map [lat, lon]
  LatLng toLatLng(List<dynamic> coord) {
    return LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());
  }

  // Calcular centro del poligono
  LatLng calcularCentro(List<LatLng> puntos) {
    double latSum = 0;
    double lonSum = 0;
    for (final p in puntos) {
      latSum += p.latitude;
      lonSum += p.longitude;
    }
    return LatLng(latSum / puntos.length, lonSum / puntos.length);
  }

  final features = data['features'];
  if (features is! List) {
    return GeoData(
      polygons: polygons,
      polylines: polylines,
      markers: markers,
      polygonTaps: polygonTaps,
    );
  }

  for (final feature in features) {
    if (feature is! Map<String, dynamic>) continue;

    final geom = feature['geometry'] as Map<String, dynamic>?;
    final props = feature['properties'] as Map<String, dynamic>? ?? {};

    if (geom == null) continue;

    switch (geom['type']) {
      case 'Polygon':
        final rings = geom['coordinates'];
        if (rings is List && rings.isNotEmpty) {
          final exteriorRing = rings[0];
          if (exteriorRing is List) {
            final puntos =
                exteriorRing.map<LatLng>((c) => toLatLng(c as List)).toList();
            final centro = calcularCentro(puntos);

            final polygon = Polygon(
              points: puntos,
              color: color.withValues(alpha: 0.3),
              borderColor: color,
              borderStrokeWidth: 2,
              label: props['id']?.toString(),
            );

            polygons.add(polygon);
            polygonTaps.add(
              PolygonTapData(
                polygon: polygon,
                center: centro,
                properties: props,
              ),
            );
          }
        }
        break;

      case 'LineString':
        final coords = geom['coordinates'];
        if (coords is List) {
          polylines.add(
            Polyline(
              points: coords.map<LatLng>((c) => toLatLng(c as List)).toList(),
              strokeWidth: 3,
              color: color,
            ),
          );
        }
        break;

      case 'Point':
        final coords = geom['coordinates'];
        if (coords is List && coords.length >= 2) {
          final point = toLatLng(coords);
          markers.add(
            Marker(
              point: point,
              width: 40,
              height: 40,
              key: ValueKey(props),
              child: GestureDetector(
                onTap:
                    onMarkerTap == null
                        ? null
                        : () => onMarkerTap(point, props),
                child: Icon(Icons.local_florist, size: 32, color: color),
              ),
            ),
          );
        }
        break;
    }
  }

  return GeoData(
    polygons: polygons,
    polylines: polylines,
    markers: markers,
    polygonTaps: polygonTaps,
  );
}

Future<void> mostrarInfoGeometrica(
  BuildContext context,
  String titulo,
  LatLng punto,
  Map<String, dynamic> propiedades,
) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...propiedades.entries.map((e) {
                return _fila(
                  Icons.info_outline,
                  _formatearTitulo(e.key),
                  e.value,
                );
              }),
              _fila(
                Icons.place,
                'Coordenadas',
                '${punto.latitude.toStringAsFixed(6)},${punto.longitude.toStringAsFixed(6)}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

String _formatearTitulo(String key) {
  String texto = key.replaceAll('_', ' ');
  if (texto.isEmpty) {
    return texto;
  }
  String primerletra = texto[0];
  String mayuscula = primerletra.toUpperCase();
  String restoText = texto.substring(1);
  String completo = mayuscula + restoText;
  return completo;
}

Widget _fila(IconData icono, String titulo, dynamic valor) {
  final texto =
      (valor == null || valor.toString().isEmpty) ? '—' : valor.toString();

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(texto, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    ),
  );
}
