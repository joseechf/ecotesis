import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'capas.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late List<MapCapas> capas;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    capas = [
      MapCapas(
        id: "sembrados",
        assetPath: "assets/geo/sembrados.geojson",
        color: const Color.fromARGB(255, 1, 70, 4),
        icon: Icons.local_florist,
      ),
      MapCapas(
        id: "terrenos",
        assetPath: "assets/geo/terrenos_alquilados.geojson",
        color: Colors.orange,
        icon: Icons.square_foot,
      ),
      MapCapas(
        id: "centros",
        assetPath: "assets/geo/centro_educativo.geojson",
        color: Colors.blue,
        icon: Icons.school,
      ),
    ];
    _cargarCapas();
  }

  Future<void> _cargarCapas() async {
    for (final capa in capas) {
      capa.data = await loadGeoJson(capa.assetPath, color: capa.color);
    }
    setState(() {});
  }

  bool _puntoEnPoligono(LatLng punto, List<LatLng> poligono) {
    bool dentro = false;

    // Coordenadas del punto a evaluar
    double px = punto.longitude;
    double py = punto.latitude;

    int j = poligono.length - 1;

    for (int i = 0; i < poligono.length; j = i++) {
      // Coordenadas del segmento del polígono
      double xi = poligono[i].longitude;
      double yi = poligono[i].latitude;

      double xj = poligono[j].longitude;
      double yj = poligono[j].latitude;

      // Verifica si el segmento está a ambos lados horizontales del punto
      bool segmentoCruzaVerticalDelPunto = (xi > px) != (xj > px);
      //evitar division por cero
      double validar = (xj - xi);
      if (validar == 0) continue;
      //Calcula la altura donde el segmento cruza la vertical del punto
      double yDondeSegmentoCruzaVertical = (yj - yi) * (px - xi) / validar + yi;

      // Verifica si el rayo horizontal del punto intercepta el segmento
      bool rayoHorizontalIntersecaSegmento = py < yDondeSegmentoCruzaVertical;

      //Si el rayo cruza el segmento, invertimos el estado
      if (segmentoCruzaVerticalDelPunto && rayoHorizontalIntersecaSegmento) {
        dentro = !dentro;
      }
    }

    return dentro;
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    for (final capa in capas) {
      if (!capa.visible || capa.data == null) {
        continue;
      }
      final polygonTaps = capa.data!.polygonTaps;
      if (polygonTaps.isEmpty) {
        continue;
      }
      for (final pt in polygonTaps) {
        if (_puntoEnPoligono(latLng, pt.polygon.points)) {
          mostrarInfoGeometrica(context, capa.id, pt.center, pt.properties);
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SelectorCapas(capas: capas, onChange: () => setState(() {})),
        const SizedBox(height: 8),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(7.7, -80.4),
              initialZoom: 10,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapakimi',
              ),
              // con un bucle cada capa pinta su geometria
              ...capas
                  .where((capa) => capa.visible && capa.data != null)
                  .expand((capa) {
                    final data = capa.data!;
                    return [
                      if (data.polygons.isNotEmpty)
                        PolygonLayer(
                          polygons: data.polygons,
                          polygonCulling: false,
                        ),

                      if (data.markers.isNotEmpty)
                        MarkerLayer(
                          markers:
                              data.markers.map((m) {
                                final propiedades =
                                    (m.key is ValueKey)
                                        ? (m.key as ValueKey).value
                                            as Map<String, dynamic>
                                        : <String, dynamic>{};
                                return Marker(
                                  point: m.point,
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      mostrarInfoGeometrica(
                                        context,
                                        capa.id,
                                        m.point,
                                        propiedades,
                                      );
                                    },
                                    child: Icon(
                                      capa.icon,
                                      color: capa.color,
                                      size: 32,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                    ];
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectorCapas extends StatelessWidget {
  final List<MapCapas> capas;
  final VoidCallback onChange;

  const _SelectorCapas({required this.capas, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          capas.map((capa) {
            return FilterChip(
              label: Text(capa.id),
              selected: capa.visible,
              onSelected: (v) {
                capa.visible = v;
                onChange();
              },
              selectedColor: capa.color.withValues(alpha: 0.2),
              checkmarkColor: capa.color,
            );
          }).toList(),
    );
  }
}
