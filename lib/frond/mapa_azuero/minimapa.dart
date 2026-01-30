import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as dev;

class MiniMap extends StatefulWidget {
  const MiniMap({Key? key}) : super(key: key);

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late final Future<GeoData> _futureSembrados;
  late final Future<GeoData> _futureTerrenos;

  bool _mostrarSembrados = true;
  bool _mostrarTerrenos = true;
  final MapController _mapController = MapController();
  GeoData? _cachedTerrenos; //para mantener la referencia
  GeoData? _cachedSembrados;

  final LayerHitNotifier<Object> _hitNotifier = LayerHitNotifier<Object>(null);
  bool _dialogAbierto = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    dev.log(' InitState called');

    _futureTerrenos = _loadAndCacheTerrenos();
    _futureSembrados = _loadAndCacheSembrados();

    _hitNotifier.addListener(_onHitChanged);
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

  Future<GeoData> _loadAndCacheTerrenos() async {
    dev.log('📂 Cargando terrenos...');
    final data = await loadGeoJson(
      'assets/geo/terrenosAlquilados.geojson',
      color: Colors.orange,
    );
    dev.log(
      '✅ Terrenos cargados: ${data.polygons.length} polígonos, ${data.polygonTaps.length} tap datas',
    );
    _cachedTerrenos = data;
    return data;
  }

  Future<GeoData> _loadAndCacheSembrados() async {
    dev.log('📂 Cargando sembrados...');
    final data = await loadGeoJson(
      'assets/geo/sembrados.geojson',
      color: const Color.fromARGB(255, 1, 70, 4),
    );
    dev.log('✅ Sembrados cargados: ${data.markers.length} markers');
    _cachedSembrados = data;
    return data;
  }

  void _onHitChanged() {
    final hit = _hitNotifier.value;
    dev.log('👆 Hit detectado: ${hit != null ? "SÍ" : "NO"}');

    if (hit == null) {
      dev.log('   Hit es null, ignorando');
      return;
    }

    dev.log('   Hit values: ${hit.hitValues.length} items');
    dev.log(
      '   Hit values types: ${hit.hitValues.map((e) => e.runtimeType).toList()}',
    );

    if (hit.hitValues.isEmpty) return;

    // Intentamos encontrar un Polygon
    final dynamic firstHit = hit.hitValues.first;
    dev.log('   Primer hit: ${firstHit.runtimeType}');

    if (_cachedTerrenos == null) {
      dev.log('   ❌ ERROR: _cachedTerrenos es null');
      return;
    }

    Polygon? hitPolygon;
    if (firstHit is Polygon) {
      hitPolygon = firstHit;
      dev.log('   ✅ Es un Polygon con ${firstHit.points.length} puntos');
    }

    if (hitPolygon == null) {
      dev.log('   ❌ No se encontró polygon en el hit');
      return;
    }

    // Buscamos el PolygonTapData correspondiente
    PolygonTapData? datos;
    try {
      datos = _cachedTerrenos!.polygonTaps.firstWhere((pt) {
        final match = _mismosPuntos(pt.polygon.points, hitPolygon!.points);
        dev.log('   Comparando polígono: match=$match');
        return match;
      });
    } catch (e) {
      dev.log('   ❌ No se encontró PolygonTapData correspondiente');
      return;
    }

    if (datos != null && !_dialogAbierto) {
      dev.log('   ✅ Mostrando diálogo para: ${datos.properties['id']}');
      _dialogAbierto = true;

      mostrarInfoTerreno(context, datos.center, datos.properties).then((_) {
        _dialogAbierto = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _hitNotifier.value = null;
        });
      });
    }
  }

  bool _mismosPuntos(List<LatLng> a, List<LatLng> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if ((a[i].latitude - b[i].latitude).abs() > 0.0000001 ||
          (a[i].longitude - b[i].longitude).abs() > 0.0000001) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _hitNotifier.removeListener(_onHitChanged);
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
              initialCenter: LatLng(40.4168, -3.7038),
              initialZoom: 13,
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

// CLASE QUE FALTABA - Selector de Capas
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
          selectedColor: const Color.fromARGB(255, 1, 70, 4).withOpacity(0.2),
          checkmarkColor: const Color.fromARGB(255, 1, 70, 4),
        ),
        FilterChip(
          label: const Text('Terrenos'),
          selected: mostrarTerrenos,
          onSelected: onToggleTerrenos,
          selectedColor: Colors.orange.withOpacity(0.2),
          checkmarkColor: Colors.orange,
        ),
      ],
    );
  }
}
