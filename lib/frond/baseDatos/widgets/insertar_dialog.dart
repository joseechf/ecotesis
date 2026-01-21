import 'package:flutter/material.dart';
import '../../../domain/entities/especie.dart';
import '../../../domain/value_objects.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

Future<Especie?> mostrarInsertarDialog(BuildContext context) async {
  /* ---------- controllers básicos ---------- */
  final nombreCientifico = TextEditingController();
  final florDistintiva = TextEditingController();
  final frutaDistintiva = TextEditingController();
  final estrato = TextEditingController();

  bool daSombra = false, saludSuelo = false, pionero = false;
  bool nativoAmerica = false, nativoPanama = false, nativoAzuero = false;

  String? huespedes, formaCrecimiento, polinizador, ambiente;

  /* ---------- datos de pantalla (temporales) ---------- */
  final nombresComunes = <NombreComun>[NombreComun(nombreComun: '')];
  final utilidades = <Utilidad>[Utilidad(utilidad: '')];
  final origenes = <Origen>[Origen(origen: '')];
  final imagenesTemp = <ImagenTemp>[ImagenTemp()]; // bytes + url provisional

  /* ---------- diálogo ---------- */
  return await showDialog<Especie>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Estilos.radioBordeGrande),
              ),
              title: Text(
                context.tr('bdInterfaz.nuevaEspecie'),
                style: TextStyle(
                  color: Estilos.verdeOscuro,
                  fontSize: Estilos.textoMedio,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    /* campos básicos (sin cambios) */
                    TextField(
                      controller: nombreCientifico,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Nlatin'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.daSombra')),
                      value: daSombra,
                      onChanged: (v) => setState(() => daSombra = v!),
                    ),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.saludSuelo')),
                      value: saludSuelo,
                      onChanged: (v) => setState(() => saludSuelo = v!),
                    ),
                    TextField(
                      controller: florDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.florDistintiva',
                        ),
                      ),
                    ),
                    TextField(
                      controller: frutaDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.frutaDistintiva',
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: huespedes,
                      items: _dropItems(context, ['Aves', 'Mono']),
                      onChanged: (v) => setState(() => huespedes = v!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.huespedes'),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: formaCrecimiento,
                      items: _dropItems(context, ['Rapido', 'Lento']),
                      onChanged: (v) => setState(() => formaCrecimiento = v!),
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.formaCrecimiento',
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.pionero')),
                      value: pionero,
                      onChanged: (v) => setState(() => pionero = v!),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: polinizador,
                      items: _dropItems(context, [
                        'Mariposa',
                        'Abeja',
                        'Mixto',
                      ]),
                      onChanged: (v) => setState(() => polinizador = v!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.polinizador'),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: ambiente,
                      items: _dropItems(context, ['Seco', 'Humedo', 'Mixto']),
                      onChanged: (v) => setState(() => ambiente = v!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.ambiente'),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        context.tr('bdInterfaz.insert.nativoAmericano'),
                      ),
                      value: nativoAmerica,
                      onChanged: (v) => setState(() => nativoAmerica = v!),
                    ),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoPanama')),
                      value: nativoPanama,
                      onChanged: (v) => setState(() => nativoPanama = v!),
                    ),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoAzuero')),
                      value: nativoAzuero,
                      onChanged: (v) => setState(() => nativoAzuero = v!),
                    ),
                    TextField(
                      controller: estrato,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.estrato'),
                      ),
                    ),

                    const SizedBox(height: 20),
                    /* Vectores de VO (sin cambios) */
                    campoVectorGenerico<NombreComun>(
                      items: nombresComunes,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Ncomun'),
                      getValor: (n) => n.nombreComun,
                      setValor: (n, v) => n.nombreComun = v,
                      crearVacio: () => NombreComun(nombreComun: ''),
                    ),
                    const SizedBox(height: 20),
                    campoVectorGenerico<Utilidad>(
                      items: utilidades,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Utilidad'),
                      getValor: (u) => u.utilidad,
                      setValor: (u, v) => u.utilidad = v,
                      crearVacio: () => Utilidad(utilidad: ''),
                    ),
                    const SizedBox(height: 20),
                    campoVectorGenerico<Origen>(
                      items: origenes,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Ubicacion'),
                      getValor: (o) => o.origen,
                      setValor: (o, v) => o.origen = v,
                      crearVacio: () => Origen(origen: ''),
                    ),
                    const SizedBox(height: 20),
                    /* Selector de imágenes (con bytes temporales) */
                    Text(
                      context.tr('bdInterfaz.insert.imagenes'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    campoImagenTemp(items: imagenesTemp, setState: setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr('buttons.cancelar')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    /* ---------- construir VO limpios ---------- */
                    final nombresLimpios =
                        nombresComunes
                            .where((n) => n.nombreComun.trim().isNotEmpty)
                            .toList();
                    final utilidadesLimpias =
                        utilidades
                            .where((u) => u.utilidad.trim().isNotEmpty)
                            .toList();
                    final origenesLimpios =
                        origenes
                            .where((o) => o.origen.trim().isNotEmpty)
                            .toList();

                    /* ---------- crear Especie (dominio) ---------- */
                    final especieDominio = Especie(
                      nombreCientifico: nombreCientifico.text.trim(),
                      daSombra: daSombra ? 1 : 0,
                      saludSuelo: saludSuelo ? 1 : 0,
                      florDistintiva:
                          florDistintiva.text.trim().isEmpty
                              ? null
                              : florDistintiva.text.trim(),
                      frutaDistintiva:
                          frutaDistintiva.text.trim().isEmpty
                              ? null
                              : frutaDistintiva.text.trim(),
                      huespedes: huespedes,
                      formaCrecimiento: formaCrecimiento,
                      pionero: pionero ? 1 : 0,
                      polinizador: polinizador,
                      ambiente: ambiente,
                      nativoAmerica: nativoAmerica ? 1 : 0,
                      nativoPanama: nativoPanama ? 1 : 0,
                      nativoAzuero: nativoAzuero ? 1 : 0,
                      estrato:
                          estrato.text.trim().isEmpty
                              ? null
                              : estrato.text.trim(),
                      nombresComunes: nombresLimpios,
                      utilidades: utilidadesLimpias,
                      origenes: origenesLimpios,
                      imagenes:
                          imagenesTemp
                              .where(
                                (i) => i.bytes != null || i.urlFoto.isNotEmpty,
                              )
                              .toList(),
                    );

                    /* ---------- bytes seleccionados ---------- */
                    final bytesList =
                        imagenesTemp
                            .map((i) => i.bytes)
                            .whereType<Uint8List>()
                            .toList();

                    /* ---------- guardar ---------- */
                    try {
                      await context.read<EspeciesProvider>().insertar(
                        especieDominio,
                        imgsBytes: bytesList,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Especie guardada correctamente'),
                          ),
                        );
                        Navigator.pop(context, especieDominio);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text(context.tr('bdInterfaz.buttons.addEspecie')),
                ),
              ],
            );
          },
        ),
  );
}

Widget campoVectorGenerico<T>({
  required List<T> items,
  required void Function(VoidCallback fn) setState,
  required String label,
  required String Function(T item) getValor,
  required void Function(T item, String value) setValor,
  required T Function() crearVacio,
}) {
  return Column(
    children: [
      ...items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: getValor(item),
                decoration: InputDecoration(labelText: label),
                onChanged: (value) {
                  setValor(item, value);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed:
                  items.length == 1
                      ? null
                      : () {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  items.add(crearVacio());
                });
              },
              icon: const Icon(Icons.add),
              tooltip: 'Agregar',
            ),
          ],
        );
      }),
    ],
  );
}

Widget campoImagenTemp({
  required List<ImagenTemp> items,
  required void Function(VoidCallback fn) setState,
}) {
  final picker = ImagePicker();

  Future<void> seleccionar(int idx) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => items[idx].bytes = bytes);
  }

  return Column(
    children:
        items.asMap().entries.map((entry) {
          final idx = entry.key;
          final img = entry.value;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // preview
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
                tooltip: 'Seleccionar',
                onPressed: () => seleccionar(idx),
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

/* ---------- helpers visuales ---------- */
List<DropdownMenuItem<String>> _dropItems(
  BuildContext ctx,
  List<String> values,
) =>
    values
        .map(
          (v) => DropdownMenuItem(
            value: v,
            child: Text(ctx.tr('bdInterfaz.insert.$v')),
          ),
        )
        .toList();
