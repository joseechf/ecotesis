import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:ecoazuero/frond/admin/model/models.dart';
import '../estilos.dart';
import '../admin/provider/admin_providers.dart';

import 'dart:convert';

/// Carga un GeoJSON y lo convierte en capas de flutter_map
/*
Future<Map<String, List<dynamic>>> loadGeoJson(
  BuildContext context,
  String path, {
  Color color = Colors.blue,
}) async {
  final str = await rootBundle.loadString(path);
  final data = jsonDecode(str);

  final polygons = <Polygon>[];
  final polylines = <Polyline>[];
  final markers = <Marker>[];

  /// Provider sin escuchar cambios
  final provider =
      (context.mounted)
          ? Provider.of<RegSiembraProvider>(context, listen: false)
          : null;

  /// GeoJSON [lon,lat] → flutter_map [lat,lon]
  LatLng toLatLng(dynamic coord) =>
      LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());

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
                /// idRegistro viene del GeoJSON
                final idRegistro = properties['name'];

                /// Buscar registro de siembra
                final lista = provider.rsiembra;

                if (provider.rsiembra == null || provider.rsiembra.isEmpty) return;

                final rSiembra = lista.firstWhere(
                  (r) => r.idRegistro == idRegistro,
                );

                /// Buscar la relación por coordenadas
                final relacion = rSiembra.relacion.firstWhere(
                  (rel) =>
                      rel.coordenadas.latitude ==
                          toLatLng(geom['coordinates']).latitude &&
                      rel.coordenadas.longitude ==
                          toLatLng(geom['coordinates']).longitude,
                );

                mostrarTarjetaPoint(context, rSiembra, relacion);
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

/// Muestra la información de un punto sembrado
void mostrarTarjetaPoint(
  BuildContext context,
  RSiembra siembra,
  SembrableRegistro relacion,
) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
        ),
        title: Text('Registro de siembra'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Estilos.paddingMedio),

              _fila(Icons.person, 'Usuario', siembra.nombreUsuario),
              _fila(
                Icons.access_time_outlined,
                'Fecha de plantación',
                siembra.fechaPlantacion.toString(),
              ),
              _fila(
                Icons.numbers,
                'Cantidad sembrada',
                relacion.cantidadSembrado,
              ),
              _fila(Icons.info_outline, 'Estado', relacion.estado),
            ],
          ),
        ),
      );
    },
  );
}

/// Fila reutilizable con icono y texto
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
*/

Future<Map<String, List<dynamic>>> loadGeoJson(
  String path, {
  Color color = Colors.blue,
  void Function(LatLng, Map<String, dynamic>)? onMarkerTap,
}) async {
  final raw = await rootBundle.loadString(path);
  final data = json.decode(raw) as Map<String, dynamic>;

  final polygons = <Polygon>[];
  final polylines = <Polyline>[];
  final markers = <Marker>[];

  // GeoJSON [lon,lat] -> flutter_map [lat,lon]
  LatLng toLatLng(List<dynamic> coord) =>
      LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());

  for (final feature in data['features']) {
    final geom = feature['geometry'] as Map<String, dynamic>;
    final props = feature['properties'] as Map<String, dynamic>? ?? {};

    switch (geom['type']) {
      case 'Polygon':
        for (final ring in geom['coordinates']) {
          polygons.add(
            Polygon(
              points:
                  (ring as List<dynamic>)
                      .map<LatLng>((coord) => toLatLng(coord))
                      .toList(),
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
            points:
                (geom['coordinates'] as List<dynamic>)
                    .map<LatLng>((coord) => toLatLng(coord))
                    .toList(),
            strokeWidth: 3,
            color: color,
          ),
        );
        break;

      case 'Point':
        final point = toLatLng(geom['coordinates'] as List);
        markers.add(
          Marker(
            point: point,
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => onMarkerTap?.call(point, props),
              child: Icon(Icons.local_library, size: 32, color: color),
            ),
          ),
        );
        break;
    }
  }

  return {'polygons': polygons, 'polylines': polylines, 'markers': markers};
}
