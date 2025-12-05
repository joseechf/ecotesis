import 'package:flutter/material.dart';
import '../../estilos.dart';

DataColumn dataColumn(texto) {
  return DataColumn(
    label: Text(
      texto,
      style: TextStyle(
        fontSize: Estilos.textoGrande,
        fontFamily: Estilos.tipografia,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
/*
Widget MenuUpdateDelete(row) {
  return PopupMenuButton<String>(
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(
      minWidth: 30, // ancho del menú
    ),
    icon: const Icon(Icons.more_vert),
    onSelected: (value) {
      if (value == 'edit') {
        () => setState(() => {});
      } else if (value == 'delete') {
        () => setState(() => terrenos.remove(row)); 
      }
    },
    itemBuilder:
        (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(children: [Icon(Icons.edit, size: 18)]),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [Icon(Icons.delete, color: Colors.red, size: 18)],
            ),
          ),
        ],
  );
}
*/