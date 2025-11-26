import 'package:flutter/material.dart';
import '../../estilos.dart';

import 'package:easy_localization/easy_localization.dart';

Future<String?> mostrarFiltroDialog(
  BuildContext context,
  String filtroActual,
) async {
  final opciones = [
    {'value': 'all', 'label': 'Todos'},
    {'value': 'Establecido al sol', 'label': 'establecido'},
    {'value': 'Mesoamerica', 'label': 'ubicacion'},
    {'value': 'abeja', 'label': 'polinizador'},
  ];

  return await showDialog<String>(
    context: context,
    builder:
        (_) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
          ),
          title: Text(context.tr('buttons.filtrar')),
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
