import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as dev;

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late final Future<GeoData> _futureSembrados;
  //late final Future<GeoData> _futureTerrenos;

  bool _mostrarSembrados = true;
  bool _mostrarTerrenos = true;
  final MapController _mapController = MapController();
  GeoData? _cachedTerrenos; //para mantener la referencia
  GeoData? _cachedSembrados;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    dev.log(' InitState called');

    //_futureTerrenos = _loadAndCacheTerrenos();
    _futureSembrados = _loadAndCacheSembrados();
  }

  Future<void> _cargarDatos() async {
    _cachedTerrenos = await loadGeoJson(
      'assets/geo/terrenosAlquilados.geojson',
      color: Colors.orange,
    );
    setState(() {});
  }

  bool _puntoEnPoligono(LatLng punto, List<LatLng> poligono) {
    bool dentro = false;
    int j = poligono.length - 1;
    for (int i = 0; i < poligono.length; j = i++) {
      if (((poligono[i].longitude > punto.longitude) !=
              (poligono[j].longitude > punto.longitude)) &&
          (punto.latitude <
              (poligono[j].latitude - poligono[i].latitude) *
                      (punto.longitude - poligono[i].longitude) /
                      (poligono[j].longitude - poligono[i].longitude) +
                  poligono[i].latitude)) {
        dentro = !dentro;
      }
    }
    return dentro;
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    if (_cachedTerrenos == null || !_mostrarTerrenos) return;

    // Buscar en qué polígono cayó el clic
    for (final pt in _cachedTerrenos!.polygonTaps) {
      if (_puntoEnPoligono(latLng, pt.polygon.points)) {
        mostrarInfoTerreno(context, pt.center, pt.properties);
        return; // Mostrar solo el primero que encuentre
      }
    }
  }

  /* Future<GeoData> _loadAndCacheTerrenos() async {
    final data = await loadGeoJson(
      'assets/geo/terrenosAlquilados.geojson',
      color: Colors.orange,
    );

    _cachedTerrenos = data;
    return data;
  }*/

  Future<GeoData> _loadAndCacheSembrados() async {
    final data = await loadGeoJson(
      'assets/geo/sembrados.geojson',
      color: const Color.fromARGB(255, 1, 70, 4),
    );
    _cachedSembrados = data;
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SelectorCapas(
          mostrarSembrados: _mostrarSembrados,
          mostrarTerrenos: _mostrarTerrenos,
          onToggleSembrados: (v) => setState(() => _mostrarSembrados = v),
          onToggleTerrenos: (v) => setState(() => _mostrarTerrenos = v),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(7.7, -80.4),
              initialZoom: 10,
              onTap: _onMapTap, //obtener el clic
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapakimi',
              ),

              if (_mostrarTerrenos && _cachedTerrenos != null)
                PolygonLayer(
                  polygons: _cachedTerrenos!.polygons,
                  polygonCulling:
                      false, // Importante: evita que seDescarten polígonos fuera de vista
                ),
              if (_mostrarSembrados && _cachedSembrados != null)
                MarkerLayer(
                  markers:
                      _cachedSembrados!.markers.map((m) {
                        final props =
                            (m.key is ValueKey)
                                ? (m.key as ValueKey).value
                                    as Map<String, dynamic>
                                : <String, dynamic>{};
                        return Marker(
                          point: m.point,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap:
                                () => mostrarInfoPunto(context, m.point, props),
                            child: const Icon(
                              Icons.local_florist,
                              color: Color.fromARGB(255, 1, 70, 4),
                              size: 32,
                            ),
                          ),
                        );
                      }).toList(),
                ),

              if (_mostrarSembrados)
                FutureBuilder<GeoData>(
                  future: _futureSembrados,
                  builder: (context, snap) {
                    if (!snap.hasData) return const SizedBox.shrink();

                    return MarkerLayer(
                      markers:
                          snap.data!.markers.map((m) {
                            final props =
                                (m.key is ValueKey)
                                    ? (m.key as ValueKey).value
                                        as Map<String, dynamic>
                                    : <String, dynamic>{};

                            return Marker(
                              point: m.point,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap:
                                    () => mostrarInfoPunto(
                                      context,
                                      m.point,
                                      props,
                                    ),
                                child: const Icon(
                                  Icons.local_florist,
                                  color: Color.fromARGB(255, 1, 70, 4),
                                  size: 32,
                                ),
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectorCapas extends StatelessWidget {
  final bool mostrarSembrados;
  final bool mostrarTerrenos;
  final ValueChanged<bool> onToggleSembrados;
  final ValueChanged<bool> onToggleTerrenos;

  const _SelectorCapas({
    required this.mostrarSembrados,
    required this.mostrarTerrenos,
    required this.onToggleSembrados,
    required this.onToggleTerrenos,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: Text('mapa.siembra'.tr()),
          selected: mostrarSembrados,
          onSelected: onToggleSembrados,
          selectedColor: const Color.fromARGB(
            255,
            1,
            70,
            4,
          ).withValues(alpha: 0.2),
          checkmarkColor: const Color.fromARGB(255, 1, 70, 4),
        ),
        FilterChip(
          label: const Text('Terrenos'),
          selected: mostrarTerrenos,
          onSelected: onToggleTerrenos,
          selectedColor: Colors.orange.withValues(alpha: 0.2),
          checkmarkColor: Colors.orange,
        ),
      ],
    );
  }
}
