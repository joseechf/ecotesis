import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'minimapa.dart';

/// Pantalla principal del mapa de Azuero
class MappAzuero extends StatefulWidget {
  const MappAzuero({super.key});

  @override
  State<MappAzuero> createState() => _MapaAzueroState();
}

class _MapaAzueroState extends State<MappAzuero> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,

      /// Contenido principal
      body: const SafeArea(child: MiniMap()),
    );
  }
}
