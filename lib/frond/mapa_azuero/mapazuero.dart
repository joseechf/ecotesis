import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'minimapa.dart';

class MappAzuero extends StatefulWidget {
  const MappAzuero({super.key});

  @override
  State<MappAzuero> createState() => _MapaAzueroState();
}

class _MapaAzueroState extends State<MappAzuero> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,

      body: const SafeArea(child: MiniMap()),
    );
  }
}
