import 'package:flutter/material.dart';

class Conservrefor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('conservacion y reforestacion')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Regresar a la pantalla anterior
              Navigator.pop(context);
            },
            child: Text('Regresar'),
          ),
        ],
      ),
    );
  }
}
