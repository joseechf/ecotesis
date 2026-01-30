import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  void initState() {
    super.initState();
    _futureSembrados = loadGeoJson(
      'assets/geo/sembrados.geojson',
      color: const Color.fromARGB(255, 1, 70, 4),
    );
    _futureTerrenos = loadGeoJson(
      'assets/geo/terrenosAlquilados.geojson',
      color: Colors.orange,
    );
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
            options: const MapOptions(
              initialCenter: LatLng(40.4168, -3.7038),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapakimi',
              ),

              // Capa de Terrenos Alquilados (Polígonos)
              if (_mostrarTerrenos)
                FutureBuilder<GeoData>(
                  future: _futureTerrenos,
                  builder: (context, snap) {
                    if (!snap.hasData) return const SizedBox.shrink();

                    final geoData = snap.data!;

                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapUp:
                          (details) => _mostrarSelectorTerrenos(
                            context,
                            geoData.polygonTaps,
                          ),
                      child: PolygonLayer(
                        polygons: geoData.polygons,
                        hitNotifier: ValueNotifier(null),
                      ),
                    );
                  },
                ),
              // Capa de Sembrados (Markers)
              if (_mostrarSembrados)
                FutureBuilder<GeoData>(
                  future: _futureSembrados,
                  builder: (context, snap) {
                    if (!snap.hasData) return const SizedBox.shrink();

                    final markers = snap.data!.markers;

                    return MarkerLayer(
                      markers:
                          markers.map((m) {
                            return Marker(
                              point: m.point,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  // Extraer propiedades del marker (almacenadas en key)
                                  final props = _extraerPropsDelMarker(m);
                                  mostrarInfoPunto(context, m.point, props);
                                },
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

  /// Extrae propiedades del marker (necesitamos modificar geo_helper para esto)
  Map<String, dynamic> _extraerPropsDelMarker(Marker marker) {
    // Por ahora retornamos vacío, ver nota abajo
    return {};
  }
}

/* ----------------------------------------------------------
   Selector de capas simple con StatefulWidget
   ---------------------------------------------------------- */
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

void _mostrarSelectorTerrenos(
  BuildContext context,
  List<PolygonTapData> polygonTaps,
) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Terrenos alquilados'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: polygonTaps.length,
              itemBuilder: (context, index) {
                final pt = polygonTaps[index];
                return ListTile(
                  leading: const Icon(Icons.crop_square, color: Colors.orange),
                  title: Text(
                    pt.properties['id']?.toString() ?? 'Terreno ${index + 1}',
                  ),
                  subtitle: Text('Dueño: ${pt.properties['dueno'] ?? 'N/A'}'),
                  trailing: Text('${pt.properties['tamano_m2'] ?? '?'} m²'),
                  onTap: () {
                    Navigator.pop(context);
                    mostrarInfoTerreno(context, pt.center, pt.properties);
                  },
                );
              },
            ),
          ),
        ),
  );
}

/*
class MiniMap extends StatefulWidget {
  const MiniMap({Key? key}) : super(key: key);

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late final Future<Map<String, List<dynamic>>> _futureSembrados;

  @override
  void initState() {
    super.initState();
    _futureSembrados = _cargarSembrados();
  }

  Future<Map<String, List<dynamic>>> _cargarSembrados() async {
    if (!mounted) {
      return {'polygons': [], 'polylines': [], 'markers': []};
    }

    return loadGeoJson(
      'assets/geo/sembrados.geojson',
      color: const Color.fromARGB(255, 1, 70, 4),
      onMarkerTap: (punto, props) {
        if (!mounted) return;
        mostrarInfoPunto(context, punto, props);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegSiembraProvider>(context);

    return Column(
      children: [
        const SelectorCapas(),
        const SizedBox(height: 8),
        Expanded(
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(40.4168, -3.7038),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapakimi',
              ),
              if (provider.mostrarSembrados)
                FutureBuilder<Map<String, List<dynamic>>>(
                  future: _futureSembrados,
                  builder: (context, snap) {
                    if (!snap.hasData) return const SizedBox.shrink();

                    final markers = snap.data!['markers']! as List<Marker>;

                    // Envolvemos cada Marker con nuestro GestureDetector
                    final wrappedMarkers =
                        markers.map((m) {
                          return Marker(
                            point: m.point,
                            width: m.width,
                            height: m.height,
                            child: _MarcadorWrapper(
                              marker: m,
                              provider: provider,
                            ),
                          );
                        }).toList();

                    return MarkerLayer(markers: wrappedMarkers);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------
   Wrapper que añade la lógica de tap y búsqueda del modelo
   ---------------------------------------------------------- */
class _MarcadorWrapper extends StatelessWidget {
  const _MarcadorWrapper({required this.marker, required this.provider});

  final Marker marker;
  final RegSiembraProvider provider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: marker.child, // el Icono que ya traía
    );
  }

  void _onTap(BuildContext context) {
    final lista = provider.rsiembra;
    if (lista.isEmpty) return;

    // Buscamos el RSiembra que tenga alguna relación con estas coordenadas
    RSiembra? encontrado;
    SembrableRegistro? relacionElegida;

    for (final r in lista) {
      for (final rel in r.relacion) {
        if (rel.coordenadas != null &&
            rel.coordenadas!.latitude == marker.point.latitude &&
            rel.coordenadas!.longitude == marker.point.longitude) {
          encontrado = r;
          relacionElegida = rel;
          break;
        }
      }
      if (encontrado != null) break;
    }

    if (encontrado == null || relacionElegida == null) return;

    mostrarTarjetaPoint(context, encontrado, relacionElegida);
  }
}

/* ----------------------------------------------------------
   Selector de capas (sin cambios)
   ---------------------------------------------------------- */
class SelectorCapas extends StatelessWidget {
  const SelectorCapas({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegSiembraProvider>(context);
    return FilterChip(
      label: Text(context.tr('mapa.siembra')),
      selected: provider.mostrarSembrados,
      onSelected: provider.toggleSembrados,
    );
  }
}

/* ----------------------------------------------------------
   Dialog con la info (igual que antes)
   ---------------------------------------------------------- */
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
        title: const Text('Registro de siembra'),
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

Widget _fila(IconData icono, String titulo, dynamic valor) {
  final valorFormateado = (valor is String) ? valor : valor.toString();
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
}*/
