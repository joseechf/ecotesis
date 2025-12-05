import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class MiniMap extends StatefulWidget {
  final Map<String, bool> layers;
  final Function(String, bool) onToggle;

  const MiniMap({Key? key, required this.layers, required this.onToggle})
    : super(key: key);

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late final Map<String, Future<Map<String, List<dynamic>>>> _futures;

  @override
  void initState() {
    super.initState();
    _futures = {
      'sembrados': loadGeoJson(
        context,
        'assets/geo/sembrados.geojson',
        color: const Color.fromARGB(255, 1, 70, 4),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LayerToggle(layers: widget.layers, onToggle: widget.onToggle),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(40.4168, -3.7038), //ubicacion inicial
                initialZoom: 12,
                minZoom: 5,
                maxZoom: 18,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.mapakimi',
                ),
                /*if (widget.layers['parques'] == true)
                  _buildPolygonLayer(_futures['parques']!),
                if (widget.layers['rios'] == true)
                  _buildPolylineLayer(_futures['rios']!),*/
                if (widget.layers['sembrados'] == true ||
                    widget.layers['sown'] == true)
                  _buildMarkerLayer(_futures['sembrados']!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /* Widget _buildPolygonLayer(Future<Map<String, List<dynamic>>> future) =>
      FutureBuilder<Map<String, List<dynamic>>>(
        future: future,
        builder: (_, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final polis = snap.data!['polygons'] as List<Polygon>;
          return PolygonLayer(polygons: polis);
        },
      );

  Widget _buildPolylineLayer(Future<Map<String, List<dynamic>>> future) =>
      FutureBuilder<Map<String, List<dynamic>>>(
        future: future,
        builder: (_, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final lines = snap.data!['polylines'] as List<Polyline>;
          return PolylineLayer(polylines: lines);
        },
      );*/

  Widget _buildMarkerLayer(Future<Map<String, List<dynamic>>> future) =>
      FutureBuilder<Map<String, List<dynamic>>>(
        future: future,
        builder: (_, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final marks = snap.data!['markers'] as List<Marker>;
          return MarkerLayer(markers: marks);
        },
      );
}

class _LayerToggle extends StatelessWidget {
  final Map<String, bool> layers;
  final Function(String, bool) onToggle;

  const _LayerToggle({required this.layers, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          layers.keys
              .map(
                (l) => FilterChip(
                  label: Text(context.tr('mapa.siembra')),
                  selected: layers[l]!,
                  onSelected: (v) => onToggle(l, v),
                ),
              )
              .toList(),
    );
  }
}
