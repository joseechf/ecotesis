import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';

Future<Especie?> mostrarInsertarDialog(BuildContext context) async {
  final tituloCtrl = TextEditingController();
  final cientificoCtrl = TextEditingController();
  final ubicacionCtrl = TextEditingController();
  final familiaCtrl = TextEditingController();
  String tipo = 'Planta';

  return await showDialog<Especie>(
    context: context,
    builder: (_) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
        ),
        title: const Text('Agregar Nueva Especie'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              DropdownButtonFormField<String>(
                value: tipo,
                items: ['Árbol', 'Flor', 'Ave', 'Planta', 'Insecto']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => tipo = val!),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                controller: cientificoCtrl,
                decoration: const InputDecoration(labelText: 'Nombre Científico'),
              ),
              TextField(
                controller: ubicacionCtrl,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              TextField(
                controller: familiaCtrl,
                decoration: const InputDecoration(labelText: 'Familia'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                Especie(
                  id: '',
                  titulo: tituloCtrl.text,
                  imagen: '',
                  tipo: tipo,
                  nombreCientifico: cientificoCtrl.text,
                  ubicacion: ubicacionCtrl.text,
                  especie: familiaCtrl.text,
                ),
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    }),
  );
}