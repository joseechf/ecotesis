import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';

import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';

Future<Especie?> mostrarTarjetaDialog(
  BuildContext context,
  Especie nuevaEspecie,
) async {
  final nombreCientifico = TextEditingController();
  final florDistintiva = TextEditingController();
  final frutaDistintiva = TextEditingController();
  final estrato = TextEditingController();

  bool daSombra = nuevaEspecie.daSombra == 1 ? true : false;
  bool saludSuelo = nuevaEspecie.saludSuelo == 1 ? true : false;
  bool pionero = nuevaEspecie.pionero == 1 ? true : false;
  bool nativoAmerica = nuevaEspecie.nativoAmerica == 1 ? true : false;
  bool nativoPanama = nuevaEspecie.nativoPanama == 1 ? true : false;
  bool nativoAzuero = nuevaEspecie.nativoAzuero == 1 ? true : false;

  String? huespedes =
      (nuevaEspecie.huespedes != null && nuevaEspecie.huespedes != '')
          ? nuevaEspecie.huespedes
          : 'vacio';
  String? formaCrecimiento =
      (nuevaEspecie.formaCrecimiento != null &&
              nuevaEspecie.formaCrecimiento != '')
          ? nuevaEspecie.formaCrecimiento
          : 'vacio';
  String? polinizador =
      (nuevaEspecie.polinizador != null && nuevaEspecie.polinizador != '')
          ? nuevaEspecie.polinizador
          : 'vacio';
  String? ambiente =
      (nuevaEspecie.ambiente != null && nuevaEspecie.ambiente != '')
          ? nuevaEspecie.ambiente
          : 'vacio';
  print('huesed: $huespedes || ${nuevaEspecie.huespedes}');
  print(
    'formaCrecimiento: $formaCrecimiento || ${nuevaEspecie.formaCrecimiento}',
  );
  print('polinizador: $polinizador || ${nuevaEspecie.polinizador}');
  print('ambiente: $ambiente || ${nuevaEspecie.ambiente}');

  /// 👇 MODELO CENTRAL
  /* final nuevaEspecie = Especie(
    nombreCientifico: '',
    nombresComunes: [NombreComun(nombres: '')],
    utilidades: [Utilidad(utilpara: '')],
    origenes: [Origen(origen: '')],
    //imagenes: [Imagen(urlFoto: '', estado: '')],
  );*/

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
                    Wrap(
                      children: [
                        Text('Da sombra ?: '),
                        Checkbox(
                          value: daSombra,
                          onChanged: (nuevoValor) {
                            setState(() {
                              daSombra = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      children: [
                        Text('Da salud al suelo ?: '),
                        Checkbox(
                          value: saludSuelo,
                          onChanged: (nuevoValor) {
                            setState(() {
                              saludSuelo = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    TextField(
                      controller: florDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Ncomun'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: frutaDistintiva,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Ncomun'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: huespedes,
                      items: const [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(value: 'Ave', child: Text('Ave')),
                        DropdownMenuItem(
                          value: 'Insecto',
                          child: Text('Insecto'),
                        ),
                      ],
                      onChanged: (val) => setState(() => huespedes = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.establecido'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: formaCrecimiento,
                      items: const [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Rapido',
                          child: Text('Rapido'),
                        ),
                        DropdownMenuItem(value: 'Lento', child: Text('Lento')),
                      ],
                      onChanged:
                          (val) => setState(() => formaCrecimiento = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.establecido'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      children: [
                        Text('Es pionero ?: '),
                        Checkbox(
                          value: pionero,
                          onChanged: (nuevoValor) {
                            setState(() {
                              pionero = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: polinizador,
                      items: const [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(
                          value: 'Mariposa',
                          child: Text('Mariposa'),
                        ),
                        DropdownMenuItem(value: 'Abeja', child: Text('Abeja')),
                        DropdownMenuItem(value: 'Mixto', child: Text('Mixto')),
                      ],
                      onChanged: (val) => setState(() => polinizador = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.establecido'),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: ambiente,
                      items: const [
                        DropdownMenuItem(value: 'vacio', child: Text('')),
                        DropdownMenuItem(value: 'Seco', child: Text('Seco')),
                        DropdownMenuItem(
                          value: 'Humedo',
                          child: Text('Humedo'),
                        ),
                        DropdownMenuItem(value: 'Mixto', child: Text('Mixto')),
                      ],
                      onChanged: (val) => setState(() => ambiente = val!),
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.establecido'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      children: [
                        Text('Nativo Americano ?: '),
                        Checkbox(
                          value: nativoAmerica,
                          onChanged: (nuevoValor) {
                            setState(() {
                              nativoAmerica = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Wrap(
                      children: [
                        Text('Nativo Panameño ?: '),
                        Checkbox(
                          value: nativoPanama,
                          onChanged: (nuevoValor) {
                            setState(() {
                              nativoPanama = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Wrap(
                      children: [
                        Text('Nativo Azuero ?: '),
                        Checkbox(
                          value: nativoAzuero,
                          onChanged: (nuevoValor) {
                            setState(() {
                              nativoAzuero = nuevoValor!;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    TextField(
                      controller: estrato,
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.Ncomun'),
                      ),
                    ),

                    SizedBox(height: 20),
                    campoVectorGenerico<NombreComun>(
                      items: nuevaEspecie.nombresComunes,
                      setState: setState,
                      label: 'Nombre común',
                      getValor: (n) => n.nombres,
                      setValor: (n, v) => n.nombres = v,
                      crearVacio: () => NombreComun(nombres: ''),
                    ),
                    SizedBox(height: 20),

                    campoVectorGenerico<Utilidad>(
                      items: nuevaEspecie.utilidades,
                      setState: setState,
                      label: 'Utilidad',
                      getValor: (u) => u.utilpara,
                      setValor: (u, v) => u.utilpara = v,
                      crearVacio: () => Utilidad(utilpara: ''),
                    ),

                    SizedBox(height: 20),

                    campoVectorGenerico<Origen>(
                      items: nuevaEspecie.origenes,
                      setState: setState,
                      label: 'Ubicación',
                      getValor: (o) => o.origen,
                      setValor: (o, v) => o.origen = v,
                      crearVacio: () => Origen(origen: ''),
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
                    nuevaEspecie.imagenes.add(
                      Imagen(
                        urlFoto: 'assets/images/casaVieja.jpg',
                        estado: 'tentativo',
                      ),
                    );
                    context.read<EspeciesProvider>().limpiarVectores(
                      nuevaEspecie,
                    );
                    await context.read<EspeciesProvider>().insertar(
                      nuevaEspecie,
                    );
                    Navigator.pop(context, nuevaEspecie);
                  },

                  child: const Text('Agregar especie'),
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
          ],
        );
      }),

      ElevatedButton(
        onPressed: () {
          setState(() {
            items.add(crearVacio());
          });
        },
        child: const Text('Agregar otro'),
      ),
    ],
  );
}
