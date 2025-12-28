import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';

Future<Especie?> mostrarInsertarDialog(BuildContext context) async {
  final nombreCientifico = TextEditingController();
  final florDistintiva = TextEditingController();
  final frutaDistintiva = TextEditingController();
  final estrato = TextEditingController();

  bool daSombra = false;
  bool saludSuelo = false;
  bool pionero = false;
  bool nativoAmerica = false;
  bool nativoPanama = false;
  bool nativoAzuero = false;

  String huespedes = 'vacio';
  String formaCrecimiento = 'vacio';
  String polinizador = 'vacio';
  String ambiente = 'vacio';

  /// 👇 MODELO CENTRAL
  final nuevaEspecie = Especie(
    nombreCientifico: '',
    nombresComunes: [NombreComun(nombres: '')],
    utilidades: [Utilidad(utilpara: '')],
    origenes: [Origen(origen: '')],
    imagenes: [Imagen(urlFoto: '', estado: '')],
  );

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
                    TextField(
                      controller: nombreCientifico,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Nlatin'),
                      ),
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.daSombra')),
                      value: daSombra,
                      onChanged: (nuevoValor) {
                        setState(() {
                          daSombra = nuevoValor!;
                        });
                      },
                    ),

                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.saludSuelo')),
                      value: saludSuelo,
                      onChanged: (nuevoValor) {
                        setState(() {
                          saludSuelo = nuevoValor!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: florDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.florDistintiva',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: frutaDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.frutaDistintiva',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: huespedes,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Ave',
                          child: Text(context.tr('bdInterfaz.insert.Ave')),
                        ),
                        DropdownMenuItem(
                          value: 'Insecto',
                          child: Text(context.tr('bdInterfaz.insert.Insecto')),
                        ),
                      ],
                      onChanged: (val) => setState(() => huespedes = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.huespedes'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: formaCrecimiento,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Rapido',
                          child: Text(context.tr('bdInterfaz.insert.Rapido')),
                        ),
                        DropdownMenuItem(
                          value: 'Lento',
                          child: Text(context.tr('bdInterfaz.insert.Lento')),
                        ),
                      ],
                      onChanged:
                          (val) => setState(() => formaCrecimiento = val!),
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.formaCrecimiento',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.pionero')),
                      value: pionero,
                      onChanged: (nuevoValor) {
                        setState(() {
                          pionero = nuevoValor!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: polinizador,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Mariposa',
                          child: Text(context.tr('bdInterfaz.insert.Mariposa')),
                        ),
                        DropdownMenuItem(
                          value: 'Abeja',
                          child: Text(context.tr('bdInterfaz.insert.Abeja')),
                        ),
                        DropdownMenuItem(
                          value: 'Mixto',
                          child: Text(context.tr('bdInterfaz.insert.Mixto')),
                        ),
                      ],
                      onChanged: (val) => setState(() => polinizador = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.polinizador'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: ambiente,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Seco',
                          child: Text(context.tr('bdInterfaz.insert.Seco')),
                        ),
                        DropdownMenuItem(
                          value: 'Humedo',
                          child: Text(context.tr('bdInterfaz.insert.Humedo')),
                        ),
                        DropdownMenuItem(
                          value: 'Mixto',
                          child: Text(context.tr('bdInterfaz.insert.Mixto')),
                        ),
                      ],
                      onChanged: (val) => setState(() => ambiente = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.ambiente'),
                      ),
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(
                        context.tr('bdInterfaz.insert.nativoAmericano'),
                      ),
                      value: nativoAmerica,
                      onChanged: (nuevoValor) {
                        setState(() {
                          nativoAmerica = nuevoValor!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoPanama')),
                      value: nativoPanama,
                      onChanged: (nuevoValor) {
                        setState(() {
                          nativoPanama = nuevoValor!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoAzuero')),
                      value: nativoAzuero,
                      onChanged: (nuevoValor) {
                        setState(() {
                          nativoAzuero = nuevoValor!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: estrato,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.estrato'),
                      ),
                    ),

                    SizedBox(height: 20),
                    campoVectorGenerico<NombreComun>(
                      items: nuevaEspecie.nombresComunes,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Ncomun'),
                      getValor: (n) => n.nombres,
                      setValor: (n, v) => n.nombres = v,
                      crearVacio: () => NombreComun(nombres: ''),
                    ),
                    SizedBox(height: 20),

                    campoVectorGenerico<Utilidad>(
                      items: nuevaEspecie.utilidades,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Utilidad'),
                      getValor: (u) => u.utilpara,
                      setValor: (u, v) => u.utilpara = v,
                      crearVacio: () => Utilidad(utilpara: ''),
                    ),

                    SizedBox(height: 20),

                    campoVectorGenerico<Origen>(
                      items: nuevaEspecie.origenes,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Ubicacion'),
                      getValor: (o) => o.origen,
                      setValor: (o, v) => o.origen = v,
                      crearVacio: () => Origen(origen: ''),
                    ),

                    SizedBox(height: 20),

                    campoVectorImagenes(
                      items: nuevaEspecie.imagenes,
                      setState: setState,
                    ),
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
                    nuevaEspecie.nombreCientifico = nombreCientifico.text;
                    nuevaEspecie.daSombra = daSombra ? 1 : 0;
                    nuevaEspecie.saludSuelo = saludSuelo ? 1 : 0;
                    nuevaEspecie.florDistintiva =
                        florDistintiva.text != '' ? florDistintiva.text : null;
                    nuevaEspecie.frutaDistintiva =
                        frutaDistintiva.text != ''
                            ? frutaDistintiva.text
                            : null;
                    nuevaEspecie.huespedes =
                        huespedes != 'vacio' ? huespedes : null;
                    nuevaEspecie.formaCrecimiento =
                        formaCrecimiento != 'vacio' ? formaCrecimiento : null;
                    nuevaEspecie.pionero = pionero ? 1 : 0;
                    nuevaEspecie.polinizador =
                        polinizador != 'vacio' ? polinizador : null;
                    nuevaEspecie.ambiente =
                        ambiente != 'vacio' ? ambiente : null;
                    nuevaEspecie.nativoAmerica = nativoAmerica ? 1 : 0;
                    nuevaEspecie.nativoPanama = nativoPanama ? 1 : 0;
                    nuevaEspecie.nativoAzuero = nativoAzuero ? 1 : 0;
                    nuevaEspecie.estrato =
                        estrato.text != '' ? estrato.text : null;

                    context.read<EspeciesProvider>().limpiarVectores(
                      nuevaEspecie,
                    );
                    try {
                      await context.read<EspeciesProvider>().insertar(
                        nuevaEspecie,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Especie guardada correctamente'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }

                    Navigator.pop(context, nuevaEspecie);
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

Widget campoVectorImagenes({
  required List<Imagen> items,
  required void Function(VoidCallback fn) setState,
}) {
  final picker = ImagePicker();

  Future<void> seleccionarImagen(int index) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      items[index].bytes = bytes;
      items[index].estado = 'tentativo';
      items[index].urlFoto = ''; // aún no existe
    });
  }

  return Column(
    children: [
      ...items.asMap().entries.map((entry) {
        final index = entry.key;
        final imagen = entry.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PREVIEW
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child:
                  imagen.bytes != null
                      ? Image.memory(imagen.bytes!, fit: BoxFit.cover)
                      : imagen.urlFoto.isEmpty
                      ? const Icon(Icons.image)
                      : imagen.urlFoto.startsWith('assets/')
                      ? Image.asset(imagen.urlFoto, fit: BoxFit.cover)
                      : Image.network(imagen.urlFoto, fit: BoxFit.cover),
            ),

            // BOTÓN SELECCIONAR
            ElevatedButton.icon(
              onPressed: () => seleccionarImagen(index),
              icon: const Icon(Icons.upload),
              label: const Text('Seleccionar'),
            ),

            // ELIMINAR
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

            // AGREGAR
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  items.add(Imagen(urlFoto: '', estado: 'tentativo'));
                });
              },
            ),
          ],
        );
      }),
    ],
  );
}
