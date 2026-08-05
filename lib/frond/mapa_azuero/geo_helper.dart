import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base_datos/widgets/crecimiento_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/reglas_rol.dart';
import '../estilos.dart';

class GeoData {
  final List<Polygon> polygons;
  final List<Marker> markers;

  GeoData({required this.polygons, required this.markers});
}

Future<GeoData> loadGeoJson(
  String path,
  {
  Color color = Colors.blue,
  IconData icon = Icons.location_on,
  void Function(LatLng, Map<String,dynamic>) ? onMarkerTap,}
) async {
  final raw = await rootBundle.loadString(path);
  final data = json.decode(raw) as Map<String, dynamic>;
  return _procesarGeoJson(
    data, color: color, icon: icon, onMarkerTap: onMarkerTap,
  );
}

Future<GeoData> loadGeoJsonFromApi (
  String url, {
    Color color = Estilos.verdePrincipal,
    IconData icon = Icons.location_on,
    void Function(LatLng, Map<String, dynamic>) ? onMarkerTap,
  }
) async {
  final response = await http.get(Uri.parse(url));
  if(response.statusCode != 200) {
    throw Exception('Error al cargar GeoJSON: ${response.statusCode}');
  }
  final data = json.decode(response.body) as Map<String, dynamic>;
  return _procesarGeoJson(
    data,
    color: color,
    icon: icon,
    onMarkerTap: onMarkerTap,
  );
}

GeoData _procesarGeoJson(
  Map<String, dynamic> data, {
    Color color = Colors.blue,
    IconData icon = Icons.location_on,
    void Function(LatLng, Map<String, dynamic>)? onMarkerTap,
  }
) {
  final polygons = <Polygon>[];
  final markers = <Marker>[];

  LatLng toLatLng(List<dynamic> coord) {
    return LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());
  }

  // calcular centro del poligono
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
  if(features is! List) {
    return GeoData(polygons: polygons, markers: markers);
  }
  for(final feature in features) {
    if(feature is! Map<String, dynamic>) continue;
    final geom = feature['geometry'] as Map<String, dynamic>?;
    final props = feature['properties'] as Map<String, dynamic>? ?? {};
    if(geom == null || geom['type'] == null) continue;
    switch(geom['type']){
      case 'Polygon':
      final rings = geom['coordinates'];
      if(rings is List && rings.isNotEmpty){
        final borderExterior = rings[0];
        if(borderExterior is List) {
          final puntos = borderExterior.map<LatLng>((c)=> toLatLng(c as List)).toList();
          final centro = calcularCentro(puntos);
          final polygon = Polygon(
            points: puntos,
            color: color.withValues(alpha: 0.3),
            borderColor: color,
            borderStrokeWidth: 2,
          );
          polygons.add(polygon);

          markers.add(
            Marker(
              point: centro,
              width: 90,
              height: 80,
              child: GestureDetector(
                onTap: () => onMarkerTap?.call(centro, props),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 36,
                      color: color,
                    ),
                    Text(
                      props['id']?.toString() ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              ),
          );
        }
      }
      break;

      case 'Point':
      final coords = geom['coordinates'];
      if(coords is List && coords .length >= 2) {
        final point = toLatLng(coords);
        markers.add(
          Marker(
            point: point,
            width: 90,
            height: 80,
            child: GestureDetector(
              onTap: onMarkerTap == null ? null : 
              () => onMarkerTap(point,props),
              child: Icon(icon,size: 32, color: color),
            ),
            ),
        );
      }
      break;
    }
  }
  return GeoData(polygons: polygons, markers: markers);
}

Future<void> mostrarInfoGeometrica(
  BuildContext context,
  String titulo,
  LatLng punto,
  Map<String, dynamic> propiedades,
){
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...propiedades.entries.map( (e){
                return _fila(
                  Icons.info_outline,
                  _formatearTitulo(e.key),
                  e.value,
                );
              }
              ),
              _fila(
                Icons.place,
                'Coordenadas',
                '${punto.latitude.toStringAsFixed(6)},${punto.longitude.toStringAsFixed(6)}',                
              ),
            ],
          ),
        ),
        actions: [
          if((propiedades['nombre cientifico - scientific name'] != null) && _isAdmin(context))
            SizedBox(
              width: 170,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final resultado = await showDialog<bool>(
                    context: context, 
                    builder: (_)=> CrecimientoDialog(idSiembra: propiedades['id'])
                  );
                  if(!context.mounted) return;
                  if(!resultado!) return;
                  if(!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.tr('mensajes.nice')), backgroundColor: Estilos.verdePrincipal,)
                  );
                }, 
                icon: const Icon(Icons.add),
                label: Text(context.tr('buttons.crecimiento')), 
                ),
            ),
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
  if(texto.isEmpty){
    return texto;
  }
  String primerletra = texto[0];
  String mayuscula = primerletra.toUpperCase();
  String restoText = texto.substring(1);
  String completo = mayuscula + restoText;
  return completo;
}

Widget _fila(IconData icono, String titulo, dynamic valor) {
  final texto = (valor == null || valor.toString().isEmpty) ? '—' : valor.toString();
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 20, color: Colors.green,),
        const SizedBox(width: 12,),
        Expanded(child: Column(
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
            const SizedBox(height: 2,),
            Text(texto, style: const TextStyle(fontSize: 15),),
          ],
        ))
      ],
    ),
  );
}

bool _isAdmin(BuildContext c) => tieneAlgunoDeLosRoles(c, ['administrador','cientifico']);