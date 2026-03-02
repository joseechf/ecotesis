import 'package:flutter/material.dart';
import '../../../domain/value_objects.dart';
import 'package:image_picker/image_picker.dart';

// widgets genéricos
Widget campoVectorGenerico<T>({
  required List<T> items,
  required void Function(VoidCallback fn) setState,
  required String label,
  required String Function(T item) getValor,
  required void Function(T item, String value) setValor,
  required T Function() crearVacio,
  List<String>? opcionesDropdown,
  String? Function(String?)? validator,
}) {
  if (items.isEmpty) {
    items.add(crearVacio());
  }
  return Column(
    children:
        items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;

          return Row(
            children: [
              Expanded(
                child:
                    opcionesDropdown == null
                        ? TextFormField(
                          key: ValueKey('$label-$idx'),
                          initialValue: getValor(item),
                          decoration: InputDecoration(labelText: label),
                          onChanged: (v) => setValor(item, v),
                          validator: validator,
                        )
                        : DropdownButtonFormField<String>(
                          initialValue:
                              getValor(item).isEmpty ? null : getValor(item),
                          decoration: InputDecoration(labelText: label),
                          items:
                              opcionesDropdown
                                  .map(
                                    (opcion) => DropdownMenuItem(
                                      value: opcion,
                                      child: Text(opcion),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setValor(item, v);
                            }
                          },
                        ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed:
                    items.length == 1
                        ? null
                        : () => setState(() => items.removeAt(idx)),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Agregar',
                onPressed: () => setState(() => items.add(crearVacio())),
              ),
            ],
          );
        }).toList(),
  );
}

Widget campoImagenTemp({
  required List<ImagenTemp> items,
  required void Function(VoidCallback fn) setState,
}) {
  final picker = ImagePicker();
  Future<void> pick(int idx) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => items[idx].bytes = bytes);
  }

  return Column(
    children:
        items.asMap().entries.map((e) {
          final idx = e.key;
          final img = e.value;
          return Row(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child:
                    img.bytes != null
                        ? Image.memory(img.bytes!, fit: BoxFit.cover)
                        : img.urlFoto.isEmpty
                        ? const Icon(Icons.image)
                        : Image.network(img.urlFoto, fit: BoxFit.cover),
              ),
              IconButton(
                icon: const Icon(Icons.upload),
                onPressed: () => pick(idx),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed:
                    items.length == 1
                        ? null
                        : () => setState(() => items.removeAt(idx)),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => items.add(ImagenTemp())),
              ),
            ],
          );
        }).toList(),
  );
}
