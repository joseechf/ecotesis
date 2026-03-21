import 'package:flutter/material.dart';
import '../../../domain/entities/especie_unificada.dart';
import 'widget_form_insert.dart';
import '../../../domain/value_objects.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'validadores.dart';
import 'widget_vo_insert.dart';

class EspecieDialog extends StatefulWidget {
  final Especie? especieInicial;

  const EspecieDialog({super.key, this.especieInicial});

  @override
  State<EspecieDialog> createState() => _EspecieDialogState();
}

class _EspecieDialogState extends State<EspecieDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCientificoCtrl;
  late TextEditingController florCtrl;
  late TextEditingController frutaCtrl;
  late TextEditingController estratoCtrl;

  String? huespedes;
  String? formaCrecimiento;
  String? polinizador;
  String? ambiente;

  bool daSombra = false;
  bool saludSuelo = false;
  bool pionero = false;
  bool nativoAmerica = false;
  bool nativoPanama = false;
  bool nativoAzuero = false;

  List<NombreComun> nombresComunes = [];
  List<Utilidad> utilidades = [];
  List<Origen> origenes = [];
  List<ImagenTemp> imagenes = [];

  bool get esEdicion => widget.especieInicial != null;

  @override
  void initState() {
    super.initState();
    final especieAuxiliar = widget.especieInicial;

    nombreCientificoCtrl = TextEditingController(
      text: especieAuxiliar?.nombreCientifico ?? '',
    );
    florCtrl = TextEditingController(
      text: especieAuxiliar?.florDistintiva ?? '',
    );
    frutaCtrl = TextEditingController(
      text: especieAuxiliar?.frutaDistintiva ?? '',
    );
    huespedes = especieAuxiliar?.huespedes;
    formaCrecimiento = especieAuxiliar?.formaCrecimiento;
    polinizador = especieAuxiliar?.polinizador;
    ambiente = especieAuxiliar?.ambiente;
    estratoCtrl = TextEditingController(text: especieAuxiliar?.estrato ?? '');

    daSombra = especieAuxiliar?.daSombra == 1;
    saludSuelo = especieAuxiliar?.saludSuelo == 1;
    pionero = especieAuxiliar?.pionero == 1;
    nativoAmerica = especieAuxiliar?.nativoAmerica == 1;
    nativoPanama = especieAuxiliar?.nativoPanama == 1;
    nativoAzuero = especieAuxiliar?.nativoAzuero == 1;

    nombresComunes = List.from(especieAuxiliar?.nombresComunes ?? []);
    utilidades = List.from(especieAuxiliar?.utilidades ?? []);
    origenes = List.from(especieAuxiliar?.origenes ?? []);
    imagenes =
        especieAuxiliar != null && especieAuxiliar.imagenes.isNotEmpty
            ? especieAuxiliar.imagenes
                .map((i) => ImagenTemp(urlFoto: i.urlFoto, bytes: i.bytes))
                .toList()
            : [ImagenTemp()];
  }

  void guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<EspeciesProvider>();

    final nombresLimpios =
        nombresComunes.where((n) => n.nombreComun.trim().isNotEmpty).toList();

    final utilidadesLimpias =
        utilidades.where((u) => u.utilidad.trim().isNotEmpty).toList();

    final origenesLimpios =
        origenes.where((o) => o.origen.trim().isNotEmpty).toList();

    final imagenesLimpias =
        imagenes.where((i) => i.bytes != null || i.urlFoto.isNotEmpty).toList();

    final bytesNuevos =
        imagenesLimpias.map((i) => i.bytes).whereType<Uint8List>().toList();

    final especieBase = Especie(
      nombreCientifico: nombreCientificoCtrl.text.trim(),
      daSombra: daSombra ? 1 : 0,
      saludSuelo: saludSuelo ? 1 : 0,
      pionero: pionero ? 1 : 0,
      nativoAmerica: nativoAmerica ? 1 : 0,
      nativoPanama: nativoPanama ? 1 : 0,
      nativoAzuero: nativoAzuero ? 1 : 0,
      florDistintiva:
          florCtrl.text.trim().isEmpty ? null : florCtrl.text.trim(),
      frutaDistintiva:
          frutaCtrl.text.trim().isEmpty ? null : frutaCtrl.text.trim(),
      estrato: estratoCtrl.text.trim().isEmpty ? null : estratoCtrl.text.trim(),
      huespedes: huespedes,
      formaCrecimiento: formaCrecimiento,
      polinizador: polinizador,
      ambiente: ambiente,
      nombresComunes: nombresLimpios,
      utilidades: utilidadesLimpias,
      origenes: origenesLimpios,
      imagenes: imagenesLimpias,
    );

    bool ok;

    if (esEdicion) {
      ok = await provider.update(especieBase, imgsBytes: bytesNuevos);
    } else {
      ok = await provider.insertar(especieBase, imgsBytes: bytesNuevos);
    }

    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EspeciesProvider>(
      builder: (context, provider, _) {
        if (provider.ultimoMensaje != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.ultimoMensaje!),
                backgroundColor:
                    provider.ultimoError ? Colors.red : Colors.green,
              ),
            );

            provider.limpiarMensaje();
          });
        }

        return AlertDialog(
          title: Text(esEdicion ? "Editar especie" : "Nueva especie"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CampoTexto(
                    label: context.tr('bdInterfaz.insert.Nlatin'),
                    controller: nombreCientificoCtrl,
                    validator:
                        esEdicion ? null : ValidadorTexto.validaObligatorio,
                    readOnly: esEdicion,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoTexto(
                    label: context.tr('bdInterfaz.insert.florDistintiva'),
                    controller: florCtrl,
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoTexto(
                    label: context.tr('bdInterfaz.insert.frutaDistintiva'),
                    controller: frutaCtrl,
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  DropdownButtonFormField<String>(
                    initialValue: huespedes,
                    onChanged: (v) => setState(() => huespedes = v),
                    decoration: InputDecoration(
                      labelText: context.tr('bdInterfaz.insert.huespedes'),
                      border: OutlineInputBorder(),
                    ),
                    items: dropItemsTraducidos(context, ['Aves', 'Mono']),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  DropdownButtonFormField<String>(
                    initialValue: formaCrecimiento,
                    decoration: InputDecoration(
                      labelText: context.tr(
                        'bdInterfaz.insert.formaCrecimiento',
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: dropItemsTraducidos(context, ['Rapido', 'Lento']),
                    onChanged: (v) => setState(() => formaCrecimiento = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  DropdownButtonFormField<String>(
                    initialValue: polinizador,
                    decoration: InputDecoration(
                      labelText: context.tr('bdInterfaz.insert.polinizador'),
                      border: OutlineInputBorder(),
                    ),
                    items: dropItemsTraducidos(context, [
                      'Mariposa',
                      'Abeja',
                      'Mixto',
                    ]),
                    onChanged: (v) => setState(() => polinizador = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  DropdownButtonFormField<String>(
                    initialValue: ambiente,
                    decoration: InputDecoration(
                      labelText: context.tr('bdInterfaz.insert.ambiente'),
                      border: OutlineInputBorder(),
                    ),
                    items: dropItemsTraducidos(context, [
                      'Seco',
                      'Humedo',
                      'Mixto',
                    ]),
                    onChanged: (v) => setState(() => ambiente = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoTexto(
                    label: context.tr('bdInterfaz.insert.estrato'),
                    controller: estratoCtrl,
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),

                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.daSombra'),
                    value: daSombra,
                    onChanged: (v) => setState(() => daSombra = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.saludSuelo'),
                    value: saludSuelo,
                    onChanged: (v) => setState(() => saludSuelo = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.pionero'),
                    value: pionero,
                    onChanged: (v) => setState(() => pionero = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.nativoAmericano'),
                    value: nativoAmerica,
                    onChanged: (v) => setState(() => nativoAmerica = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.nativoPanama'),
                    value: nativoPanama,
                    onChanged: (v) => setState(() => nativoPanama = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  CampoCheck(
                    label: context.tr('bdInterfaz.insert.nativoAzuero'),
                    value: nativoAzuero,
                    onChanged: (v) => setState(() => nativoAzuero = v),
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  campoVectorGenerico<NombreComun>(
                    items: nombresComunes,
                    setState: setState,
                    label: context.tr('bdInterfaz.insert.Ncomun'),
                    getValor: (n) => n.nombreComun,
                    setValor: (n, v) => n.nombreComun = v,
                    crearVacio: () => NombreComun(nombreComun: ''),
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  campoVectorGenerico<Utilidad>(
                    items: utilidades,
                    setState: setState,
                    label: context.tr('bdInterfaz.insert.Utilidad.titulo'),
                    getValor: (u) => u.utilidad,
                    setValor: (u, v) => u.utilidad = v,
                    crearVacio: () => Utilidad(utilidad: ''),
                    opcionesDropdown: [
                      context.tr('bdInterfaz.insert.Utilidad.frutal'),
                      context.tr('bdInterfaz.insert.Utilidad.maderal'),
                      context.tr('bdInterfaz.insert.Utilidad.ganado'),
                      context.tr('bdInterfaz.insert.Utilidad.medicinal'),
                    ],
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  campoVectorGenerico<Origen>(
                    items: origenes,
                    setState: setState,
                    label: context.tr('bdInterfaz.insert.Ubicacion'),
                    getValor: (o) => o.origen,
                    setValor: (o, v) => o.origen = v,
                    crearVacio: () => Origen(origen: ''),
                    validator: ValidadorTexto.validaNoObligatorio,
                  ),
                  const SizedBox(height: Estilos.paddingMedio),
                  // imágenes
                  Text(
                    context.tr('bdInterfaz.insert.Imagenes'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  campoImagenTemp(items: imagenes, setState: setState),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr('buttons.cancelar')),
            ),
            ElevatedButton(
              onPressed: provider.cargandoData ? null : guardar,
              child:
                  provider.cargandoData
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(
                        esEdicion
                            ? context.tr('buttons.update')
                            : context.tr('buttons.add'),
                      ),
            ),
          ],
        );
      },
    );
  }
}
