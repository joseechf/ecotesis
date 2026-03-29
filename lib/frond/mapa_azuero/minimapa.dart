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
      capa.data = await loadGeoJson(
        capa.assetPath,
        color: capa.color,
        icon: capa.icon,
        onPolygonTap: (punto, props) {
          mostrarInfoGeometrica(context, capa.id, punto, props);
        },
        onMarkerTap: (punto, props) {
          mostrarInfoGeometrica(context, capa.id, punto, props);
        },
      );
    }
    setState(() {});
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
                        MarkerLayer(markers: data.markers),
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
