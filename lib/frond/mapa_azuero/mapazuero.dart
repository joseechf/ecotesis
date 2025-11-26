import 'package:ecoazuero/frond/iureutilizables/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'minimapa.dart';

class mappAzuero extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<mappAzuero> {
  final _layers = <String, bool>{
    /*'parques': true,
    'rios': false,*/
    'bibliotecas': false,
  };

  void _toggle(String layer, bool value) =>
      setState(() => _layers[layer] = value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SafeArea(child: MiniMap(layers: _layers, onToggle: _toggle)),
    );
  }
}
