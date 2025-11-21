import 'package:flutter/material.dart';
import '../../estilos.dart';

Future<String?> mostrarFiltroDialog(
  BuildContext context,
  String filtroActual,
) async {
  final opciones = [
    {'value': 'all', 'label': 'Todos'},
    {'value': 'Sol', 'label': 'Establecido al sol'},
    {'value': 'ubicacion', 'label': 'Mesoamerica'},
    {'value': 'polinizador', 'label': 'abeja'},
  ];

  return await showDialog<String>(
    context: context,
    builder:
        (_) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
          ),
          title: const Text('Filtrar por tipo'),
          children:
              opciones.map((op) {
                return RadioListTile<String>(
                  title: Text(op['label']!),
                  value: op['value']!,
                  groupValue: filtroActual,
                  onChanged: (val) => Navigator.pop(context, val),
                );
              }).toList(),
        ),
  );
}
