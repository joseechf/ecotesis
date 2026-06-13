import 'package:ecoazuero/backend/llamadas_remotas/llamadas_flora.dart';
import 'widget_form_insert.dart';
import '../../iureutilizables/widgetpersonalizados.dart';
import 'package:flutter/material.dart';
import '../../estilos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'validadores.dart';
import '../../iureutilizables/errores.dart';


class CrecimientoDialog extends StatefulWidget {
  final int idSiembra;
  const CrecimientoDialog({super.key, required this.idSiembra});

  @override  
  State<CrecimientoDialog> createState() => _CrecimientoDialogState();
}

class _CrecimientoDialogState extends State<CrecimientoDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final alturaCtrl = TextEditingController();
  final salud = TextEditingController();
  final afeccion = TextEditingController();

  void mostrarErrorUI(BuildContext context, OnError error) {
    debugPrint(' ERROR REAL UI: ${error.source} | ${error.type} | ${error.message}',);
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(
          '${error.source}: ${error.message}'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), 
          child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void guardar() async {
    bool result = false;
    try {
      if(! _formKey.currentState!.validate()) throw Exception('falló la validacion');
      if(selectedDate == null) throw Exception('valor fecha vacío');
    } catch (e) {
      final error = OnError(
        type: 'ui',
        message: e.toString(),
        source: 'siembra',
      );
      if(!mounted) return;
      mostrarErrorUI(context, error);
    }
    final fechaFormato = '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2,"0")}-${selectedDate!.day.toString().padLeft(2,"0")}';
    final data = {
      "id_siembra": widget.idSiembra,
      "fecha": fechaFormato,
      "altura_promedio": double.tryParse(alturaCtrl.text),
      "porcentaje_salud": int.tryParse(salud.text),
      "afeccion": afeccion.text,
    };
    try {
      await insertAPI(data, 'insertCrecimiento', null);
      if(!mounted) return;
      Navigator.pop(context,result);
    } on OnError catch (e) {
      if(context.mounted){
        if(!mounted) return;
        mostrarErrorUI(context, e);
      }
    } catch (e) {
      final error = OnError(
        type: 'ui',
        message: e.toString(),
        source: 'crecimiento',
      );
      if(!mounted) return;
      mostrarErrorUI(context, error);
    }
  }

  @override  
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(context.tr('admin.crecimiento.seguimiento')),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedDate != null
                  ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                  : 'YYYY-MM-DD',
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await selectDate(context);

                  setState(() {
                    selectedDate = result ?? result;
                  });
                },
                child: Text(context.tr('buttons.fecha')),
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              TextField(
                    controller: alturaCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.tr('admin.crecimiento.altura'),
                      border: OutlineInputBorder(),
                      suffixText: "cm",
                    ),
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              TextFormField(
                    controller: salud,
                    decoration: InputDecoration(
                      labelText: context.tr('admin.crecimiento.salud'),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Ingrese el % de salud';
                      }
                      final n = int.tryParse(value);
                      if(n == null){
                        return 'Debe ser un número';
                      }
                      if(n < 0 || n > 100){
                        return 'El rango debe ser de 0 a 100';
                      }
                      return null;
                      },
              ),
              const SizedBox(height: Estilos.paddingMedio,),
              CampoTexto(
                    label: context.tr('admin.crecimiento.afeccion'),
                    controller: afeccion,
                    validator: ValidadorTexto.validaNoObligatorio,
              ),
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
          onPressed: guardar,
          child: Text(context.tr('buttons.add')),
        ),
      ],
    );
  }
}