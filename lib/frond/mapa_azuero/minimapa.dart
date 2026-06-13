import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'geo_helper.dart';
import 'capas.dart';
import 'package:ecoazuero/config/config.dart';
import 'package:easy_localization/easy_localization.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});
  @override
  State <MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap>{
  late List<MapCapas> capas;

  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    final  urlS = '$baseUrl/getsiembra';
    final urlT = '$baseUrl/getterreno';
    capas = [
      MapCapas(id: context.tr('admin.capas.siembra'),
       url: urlS, esApi: true, color: Color.fromARGB(255, 10, 240, 60), icon: Icons.spa),
      MapCapas(id: context.tr('admin.capas.terrenos'),
        url: urlT, esApi: true, color: Colors.orange, icon: Icons.landscape),
      MapCapas(id: context.tr('admin.capas.centros'),
       url: "assets/geo/centro_educativo.geojson",
        esApi: false, color: Colors.blue, icon: Icons.school),
    ];
    _cargarCapas();
  }

  Future<void> _cargarCapas() async {
    for(final capa in capas) {
      try {
        if(capa.esApi) {
          capa.data = await loadGeoJsonFromApi(
            capa.url,
            color: capa.color,
            icon: capa.icon,
            onMarkerTap: (punto,props) {
              mostrarInfoGeometrica(context, capa.id, punto, props);
            },
          );
        } else {
          capa.data = await loadGeoJson(
            capa.url,
            color: capa.color,
            icon: capa.icon,
            onMarkerTap: (punto,props) {
              mostrarInfoGeometrica(context, capa.id, punto, props);
            },
          );
        }
      } catch (e) {
        debugPrint(' Error cargando capa ${capa.id}: $e');
      }
    }
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SelectorCapas(capas: capas, onChange: () => setState(() {})),
        const SizedBox(height: 8,),
        Expanded(child: 
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(7.7,-80.4),
            initialZoom: 10,
          ), 
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.ecoazuero',
            ),
            ...capas
              .where((capa) => capa.visible && capa.data != null)
              .expand((capa) {
                final data = capa.data!;
                return [
                  if(data.polygons.isNotEmpty)
                    PolygonLayer(polygons: data.polygons,
                      polygonCulling: false,
                    ),
                    if(data.markers.isNotEmpty)
                      MarkerLayer(markers: data.markers),
                ];
              }),
          ],
        ),
        )
      ],
    );
  }
}

class _SelectorCapas extends StatelessWidget {
  final List<MapCapas> capas;
  final VoidCallback onChange;

  const  _SelectorCapas({required this.capas, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: 
        capas.map((capa){
          return FilterChip(
            label: Text(capa.id),
            selected: capa.visible,
            onSelected: (v){
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