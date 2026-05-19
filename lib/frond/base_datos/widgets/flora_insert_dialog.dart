import 'package:flutter/material.dart';
import '../../../domain/entities/especie_unificada.dart';
import 'widget_form_insert.dart';
import '../../../domain/value_objects.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/especies_provider.dart';
import 'package:provider/provider.dart';
import 'validadores.dart';
import 'widget_vo_insert.dart';

import 'package:flutter/foundation.dart';
import '../../iureutilizables/errores.dart';

class EspecieDialogInsertEdit extends StatefulWidget {
  final Especie? especieInicial;

  const EspecieDialogInsertEdit({super.key, this.especieInicial});

  @override
  State<EspecieDialogInsertEdit> createState() => _EspecieDialogInsertEditState();
}

class _EspecieDialogInsertEditState extends State<EspecieDialogInsertEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCientificoCtrl;
  late TextEditingController florCtrl;
  late TextEditingController frutaCtrl;
  late TextEditingController estratoCtrl;
  late TextEditingController coberturaCtrl;

  String? huespedes;
  String? formaCrecimiento;
  String? polinizador;
  String? ambiente;
  String? establecidoSolSombra;

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
    coberturaCtrl = TextEditingController(
      text: especieAuxiliar?.cobertura.toString() ?? '',
    );
    establecidoSolSombra = especieAuxiliar?.establecidoSolSombra;
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

void mostrarErrorUI(BuildContext context, OnError error) {
  debugPrint(
    'ERROR REAL UI: ${error.source} | ${error.type} | ${error.status} | ${error.message}',
  );
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(
        '${error.source}: ocurrió un error. Intenta nuevamente.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}

  void guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<EspeciesProvider>();
    double cob = double.tryParse(coberturaCtrl.text) ?? 0;

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
      cobertura: cob,
      establecidoSolSombra: establecidoSolSombra,
      nombresComunes: nombresLimpios,
      utilidades: utilidadesLimpias,
      origenes: origenesLimpios,
      imagenes: imagenesLimpias,
    );
    final ok = esEdicion
    ? await provider.update(especieBase, imgsBytes: bytesNuevos)
    : await provider.insertar(especieBase, imgsBytes: bytesNuevos);
    if (!mounted) return;
    if (!ok) {
      final error = provider.error;
      if (error != null) {
        mostrarErrorUI(context, error);
      } else {
        mostrarErrorUI(
          context,
          OnError(
            type: 'ui',
            message: 'Operación fallida sin detalle',
            source: 'EspecieDialog',
          ),
        );
      }
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EspeciesProvider>(
      builder: (context, provider, _) {

        return AlertDialog(
          title: Text(
            esEdicion
                ? context.tr('bdInterfaz.editarEspecie')
                : context.tr('bdInterfaz.nuevoRegistro'),
          ),
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
                  DropdownButtonFormField<String>(
                    initialValue: establecidoSolSombra,
                    decoration: InputDecoration(
                      labelText: context.tr(
                        'bdInterfaz.insert.establecidoSolSombra',
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: dropItemsTraducidos(context, [
                      'Sol',
                      'Sombra',
                      'Mixto',
                    ]),
                    onChanged: (v) => setState(() => establecidoSolSombra = v),
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
                  TextField(
                    controller: coberturaCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.tr('bdInterfaz.insert.cob'),
                      border: OutlineInputBorder(),
                    ),
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
                  campoUtilidades(
                    items: utilidades,
                    setState: setState,
                    label: context.tr('bdInterfaz.insert.Utilidad.titulo'),
                    context: context,
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
              onPressed: () => Navigator.pop(context, false),
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
