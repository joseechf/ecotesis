import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';

Future<Especie?> mostrarEditarDialog(
  BuildContext context,
  Especie especieActual,
) async {
  final Map<String, dynamic> cambios = {};
  cambios['nombreCientifico'] = especieActual.nombreCientifico;
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

  String huespedes = especieActual.huespedes ?? 'vacio';
  String formaCrecimiento = especieActual.formaCrecimiento ?? 'vacio';
  String polinizador = especieActual.polinizador ?? 'vacio';
  String ambiente = especieActual.ambiente ?? 'vacio';

  final nombresComunes = List<NombreComun>.from(especieActual.nombresComunes);
  final utilidades = List<Utilidad>.from(especieActual.utilidades);
  final origenes = List<Origen>.from(especieActual.origenes);
  final imagenes = List<Imagen>.from(
    especieActual.imagenes.map(
      (img) => Imagen(urlFoto: img.urlFoto, estado: img.estado),
    ),
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
                context.tr('bdInterfaz.editarEspecie'),
                style: TextStyle(
                  color: Estilos.verdeOscuro,
                  fontSize: Estilos.textoMedio,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      especieActual.nombreCientifico,
                      style: TextStyle(color: Estilos.verdePrincipal),
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.daSombra')),
                      value: daSombra,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != daSombra) {
                            cambios['daSombra'] = valor;
                          } else {
                            cambios.remove('daSombra');
                          }
                          daSombra = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.saludSuelo')),
                      value: saludSuelo,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != saludSuelo) {
                            cambios['saludSuelo'] = valor;
                          } else {
                            cambios.remove('saludSuelo');
                          }
                          saludSuelo = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: florDistintiva,
                      onChanged: (valor) {
                        if (valor != florDistintiva.text) {
                          cambios['florDistintiva'] = valor;
                        } else {
                          cambios.remove('florDistintiva');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.florDistintiva',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: frutaDistintiva,
                      onChanged: (valor) {
                        if (valor != frutaDistintiva.text) {
                          cambios['frutaDistintiva'] = valor;
                        } else {
                          cambios.remove('frutaDistintiva');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.frutaDistintiva',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: huespedes,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: const Text('')),
                        DropdownMenuItem(
                          value: 'Aves',
                          child: Text(context.tr('bdInterfaz.insert.Ave')),
                        ),
                        DropdownMenuItem(
                          value: 'Mono',
                          child: Text(context.tr('bdInterfaz.insert.Mono')),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != huespedes) {
                          cambios['huespedes'] = valor;
                        } else {
                          cambios.remove('huespedes');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.huespedes'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: formaCrecimiento,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: const Text('')),
                        DropdownMenuItem(
                          value: 'Rapido',
                          child: Text(context.tr('bdInterfaz.insert.Rapido')),
                        ),
                        DropdownMenuItem(
                          value: 'Lento',
                          child: Text(context.tr('bdInterfaz.insert.Lento')),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != formaCrecimiento) {
                          cambios['formaCrecimiento'] = valor;
                        } else {
                          cambios.remove('formaCrecimiento');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr(
                          'bdInterfaz.insert.formaCrecimiento',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.pionero')),
                      value: pionero,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != pionero) {
                            cambios['pionero'] = valor;
                          } else {
                            cambios.remove('pionero');
                          }
                          pionero = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: polinizador,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: const Text('')),
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
                      onChanged: (valor) {
                        if (valor != polinizador) {
                          cambios['polinizador'] = valor;
                        } else {
                          cambios.remove('polinizador');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.polinizador'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: ambiente,
                      items: [
                        DropdownMenuItem(value: 'vacio', child: const Text('')),
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
                      onChanged: (valor) {
                        if (valor != ambiente) {
                          cambios['ambiente'] = valor;
                        } else {
                          cambios.remove('ambiente');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.ambiente'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(
                        context.tr('bdInterfaz.insert.nativoAmericano'),
                      ),
                      value: nativoAmerica,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != nativoAmerica) {
                            cambios['nativoAmerica'] = valor;
                          } else {
                            cambios.remove('nativoAmerica');
                          }
                          nativoAmerica = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoPanama')),
                      value: nativoPanama,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != nativoPanama) {
                            cambios['nativoPanama'] = valor;
                          } else {
                            cambios.remove('nativoPanama');
                          }
                          nativoPanama = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      title: Text(context.tr('bdInterfaz.insert.nativoAzuero')),
                      value: nativoAzuero,
                      onChanged: (valor) {
                        setState(() {
                          if (valor != nativoAzuero) {
                            cambios['nativoAzuero'] = valor;
                          } else {
                            cambios.remove('nativoAzuero');
                          }
                          nativoAzuero = valor!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: estrato,
                      onChanged: (valor) {
                        if (valor != estrato.text) {
                          cambios['estrato'] = valor;
                        } else {
                          cambios.remove('estrato');
                        }
                      },
                      decoration: InputDecoration(
                        labelText: context.tr('bdInterfaz.insert.estrato'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    campoVectorGenerico<NombreComun>(
                      items: nombresComunes,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Ncomun'),
                      getValor: (n) => n.nombres,
                      setValor: (n, v) => n.nombres = v,
                      crearVacio: () => NombreComun(nombres: ''),
                    ),
                    const SizedBox(height: 20),

                    campoVectorGenerico<Utilidad>(
                      items: utilidades,
                      setState: setState,
                      label: context.tr('bdInterfaz.insert.Utilidad'),
                      getValor: (u) => u.utilpara,
                      setValor: (u, v) => u.utilpara = v,
                      crearVacio: () => Utilidad(utilpara: ''),
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

                    campoVectorImagenesEditable(
                      items: imagenes,
                      setState: setState,
                    ),
                    const SizedBox(height: 20),
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
                    especieActual
                      ..nombreCientifico = especieActual.nombreCientifico
                      ..daSombra = daSombra ? 1 : 0
                      ..saludSuelo = saludSuelo ? 1 : 0
                      ..florDistintiva =
                          florDistintiva.text.isEmpty
                              ? null
                              : florDistintiva.text
                      ..frutaDistintiva =
                          frutaDistintiva.text.isEmpty
                              ? null
                              : frutaDistintiva.text
                      ..huespedes = huespedes == 'vacio' ? null : huespedes
                      ..formaCrecimiento =
                          formaCrecimiento == 'vacio' ? null : formaCrecimiento
                      ..pionero = pionero ? 1 : 0
                      ..polinizador =
                          polinizador == 'vacio' ? null : polinizador
                      ..ambiente = ambiente == 'vacio' ? null : ambiente
                      ..nativoAmerica = nativoAmerica ? 1 : 0
                      ..nativoPanama = nativoPanama ? 1 : 0
                      ..nativoAzuero = nativoAzuero ? 1 : 0
                      ..estrato = estrato.text.isEmpty ? null : estrato.text
                      ..nombresComunes = nombresComunes
                      ..utilidades = utilidades
                      ..origenes = origenes
                      ..imagenes = imagenes;
                    cambios['NombreComun'] = nombresComunes;
                    cambios['Utilidad'] = utilidades;
                    cambios['Imagen'] = imagenes;
                    cambios['Origen'] = origenes;

                    try {
                      final res = await context.read<EspeciesProvider>().update(
                        cambios,
                      );
                      if (res) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Especie actualizada correctamente',
                              ),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('NO SE ACTUALIZO !!!!!'),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                    if (context.mounted) {
                      Navigator.pop(context, especieActual);
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
          final index = entry.key;
          final item = entry.value;

          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: getValor(item),
                  decoration: InputDecoration(labelText: label),
                  onChanged: (value) => setValor(item, value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed:
                    items.length == 1
                        ? null
                        : () => setState(() => items.removeAt(index)),
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

Widget campoVectorImagenesEditable({
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
      items[index].urlFoto = '';
    });
  }

  return Column(
    children:
        items.asMap().entries.map((entry) {
          final index = entry.key;
          final imagen = entry.value;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child:
                        imagen.bytes != null
                            ? Image.memory(imagen.bytes!, fit: BoxFit.cover)
                            : imagen.urlFoto.isEmpty
                            ? const Icon(Icons.image)
                            : imagen.urlFoto.startsWith('assets/')
                            ? Image.asset(imagen.urlFoto, fit: BoxFit.cover)
                            : Image.network(imagen.urlFoto, fit: BoxFit.cover),
                  ),

                  IconButton(
                    onPressed: () => seleccionarImagen(index),
                    icon: const Icon(Icons.upload),
                    tooltip: 'Seleccionar',
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed:
                            items.length == 1
                                ? null
                                : () => setState(() => items.removeAt(index)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed:
                            () => setState(
                              () => items.add(
                                Imagen(urlFoto: '', estado: 'tentativo'),
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: imagen.estado,
                items: const [
                  DropdownMenuItem(
                    value: 'tentativo',
                    child: Text('Tentativo'),
                  ),
                  DropdownMenuItem(
                    value: 'comprobado',
                    child: Text('comprobado'),
                  ),
                ],
                onChanged: (val) => setState(() => imagen.estado = val!),
                decoration: const InputDecoration(
                  labelText: 'Estado de la imagen',
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
  );
}
