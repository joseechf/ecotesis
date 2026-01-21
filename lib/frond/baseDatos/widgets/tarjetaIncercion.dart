import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../../domain/entities/especie.dart';
import '../../../domain/value_objects.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';

Future<Especie?> mostrarEditarDialog(
  BuildContext context,
  Especie especieActual, {
  List<Uint8List> imgsBytes = const [],
}) async {
  /* ---------- controllers básicos ---------- */
  final florDistintiva = TextEditingController(
    text: especieActual.florDistintiva ?? '',
  );
  final frutaDistintiva = TextEditingController(
    text: especieActual.frutaDistintiva ?? '',
  );
  final estrato = TextEditingController(text: especieActual.estrato ?? '');

  bool daSombra = especieActual.daSombra == 1;
  bool saludSuelo = especieActual.saludSuelo == 1;
  bool pionero = especieActual.pionero == 1;
  bool nativoAmerica = especieActual.nativoAmerica == 1;
  bool nativoPanama = especieActual.nativoPanama == 1;
  bool nativoAzuero = especieActual.nativoAzuero == 1;

  String? huespedes = especieActual.huespedes;
  String? formaCrecimiento = especieActual.formaCrecimiento;
  String? polinizador = especieActual.polinizador;
  String? ambiente = especieActual.ambiente;

  /* ---------- listas de VO (copia para editar) ---------- */
  final nombresComunes =
      especieActual.nombresComunes.isNotEmpty
          ? especieActual.nombresComunes
              .map((n) => NombreComun(nombreComun: n.nombreComun))
              .toList()
          : [NombreComun(nombreComun: '')];
  final utilidades =
      especieActual.utilidades.isNotEmpty
          ? especieActual.utilidades
              .map((u) => Utilidad(utilidad: u.utilidad))
              .toList()
          : [Utilidad(utilidad: '')];
  final origenes =
      especieActual.origenes.isNotEmpty
          ? especieActual.origenes.map((o) => Origen(origen: o.origen)).toList()
          : [Origen(origen: '')];

  /* ---------- imágenes: copia desde dominio ---------- */
  final imagenesTemp =
      especieActual.imagenes.isNotEmpty
          ? especieActual.imagenes
              .map((i) => ImagenTemp(urlFoto: i.urlFoto, bytes: i.bytes))
              .toList()
          : [ImagenTemp()];

  if (imagenesTemp.isEmpty) imagenesTemp.add(ImagenTemp());

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
                context.tr('bdInterfaz.editarEspecie'),
                style: TextStyle(
                  color: Estilos.verdeOscuro,
                  fontSize: Estilos.textoMedio,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      especieActual.nombreCientifico,
                      style: TextStyle(color: Estilos.verdePrincipal),
                    ),
                    const SizedBox(height: 20),

                    /* ---------- campos básicos ---------- */
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
                      value: huespedes,
                      items: _dropItems(context, ['Aves', 'Mono']),
                      onChanged: (v) => setState(() => huespedes = v!),
                    ),
                    DropdownButtonFormField<String>(
                      value: formaCrecimiento,
                      items: _dropItems(context, ['Rapido', 'Lento']),
                      onChanged: (v) => setState(() => formaCrecimiento = v!),
                    ),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.pionero')),
                      value: pionero,
                      onChanged: (v) => setState(() => pionero = v!),
                    ),
                    DropdownButtonFormField<String>(
                      value: polinizador,
                      items: _dropItems(context, [
                        'Mariposa',
                        'Abeja',
                        'Mixto',
                      ]),
                      onChanged: (v) => setState(() => polinizador = v!),
                    ),
                    DropdownButtonFormField<String>(
                      value: ambiente,
                      items: _dropItems(context, ['Seco', 'Humedo', 'Mixto']),
                      onChanged: (v) => setState(() => ambiente = v!),
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

                    /* Vectores VO */
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

                    /* ---------- imágenes ---------- */
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
                    /* ---------- ensamblar Especie (dominio) ---------- */
                    final especieEditada = Especie(
                      nombreCientifico: especieActual.nombreCientifico,
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
                      nombresComunes:
                          nombresComunes
                              .where((n) => n.nombreComun.trim().isNotEmpty)
                              .toList(),
                      utilidades:
                          utilidades
                              .where((u) => u.utilidad.trim().isNotEmpty)
                              .toList(),
                      origenes:
                          origenes
                              .where((o) => o.origen.trim().isNotEmpty)
                              .toList(),
                      imagenes:
                          imagenesTemp
                              .where(
                                (i) =>
                                    (i.bytes != null) || (i.urlFoto.isNotEmpty),
                              )
                              .toList(),
                    );

                    /* ---------- bytes nuevos ---------- */
                    final bytesNuevos =
                        imagenesTemp
                            .map((i) => i.bytes)
                            .whereType<Uint8List>()
                            .toList();

                    /* ---------- enviar ---------- */
                    try {
                      final ok = await context.read<EspeciesProvider>().update(
                        especieEditada,
                        imgsBytes: bytesNuevos,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context, ok ? especieEditada : null);
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.pop(context, null);
                    }
                  },
                  child: Text(context.tr('bdInterfaz.buttons.updateEspecie')),
                ),
              ],
            );
          },
        ),
  );
}

/* ---------- widgets genéricos ---------- */
Widget campoVectorGenerico<T>({
  required List<T> items,
  required void Function(VoidCallback fn) setState,
  required String label,
  required String Function(T item) getValor,
  required void Function(T item, String value) setValor,
  required T Function() crearVacio,
}) {
  return Column(
    children:
        items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: getValor(item),
                  decoration: InputDecoration(labelText: label),
                  onChanged: (v) => setValor(item, v),
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
