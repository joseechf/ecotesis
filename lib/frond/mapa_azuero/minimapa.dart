import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../admin/provider/admin_providers.dart';

import '../admin/model/models.dart';
import '../../frond/estilos.dart';

/*
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
*/

/// Mini mapa con capas controladas por Provider
/*class MiniMap extends StatefulWidget {
  const MiniMap({Key? key}) : super(key: key);

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  /// Futuros para cargar capas GeoJSON
  late final Map<String, Future<Map<String, List<dynamic>>>> futurosCapas;

  @override
  void initState() {
    super.initState();

    futurosCapas = {
      'sembrados': loadGeoJson(
        context,
        'assets/geo/sembrados.geojson',
        color: const Color.fromARGB(255, 1, 70, 4),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    /// Provider de registro de siembra
    final provider = Provider.of<RegSiembraProvider>(context);

    return Column(
      children: [
        /// Selector de capas
        const SelectorCapas(),
        const SizedBox(height: 8),

        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(40.4168, -3.7038),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapakimi',
              ),

              /// Capa de sembrados
              if (provider.mostrarSembrados)
                _capaMarcadores(futurosCapas['sembrados']!),
            ],
          ),
        ),
      ],
    );
  }

  /// Capa de marcadores desde GeoJSON
  Widget _capaMarcadores(Future<Map<String, List<dynamic>>> future) {
    return FutureBuilder<Map<String, List<dynamic>>>(
      future: future,
      builder: (_, snap) {
        if (!snap.hasData) return const SizedBox.shrink();

        final marcadores = snap.data!['markers'] as List<Marker>;
        return MarkerLayer(markers: marcadores);
      },
    );
  }
}

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
}*/

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

  /// Carga el GeoJSON y devuelve las capas
  Future<Map<String, List<dynamic>>> _cargarSembrados() async {
    return loadGeoJson(
      'assets/geo/sembrados.geojson',
      color: const Color.fromARGB(255, 1, 70, 4),
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
}
