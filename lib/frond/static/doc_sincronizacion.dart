import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import '../iureutilizables/footer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../estilos.dart';

class ExplicacionSincronizacion extends StatelessWidget {
  const ExplicacionSincronizacion({super.key});

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final isMobil = anchoPantalla < Estilos.cambioMenu;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobil ? const MobileMenu() : null,

      body: SafeArea(child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              //campo de proposito
              TextFormField(
                initialValue: context.tr('texts.doc_sinc.proposito'),
                decoration: const InputDecoration(
                  labelText: 'proposito',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                enabled: false,
              ),

              const SizedBox(height: 10,),

              //campo de uso
              TextFormField(
                initialValue: context.tr('texts.doc_sinc.uso'),
                decoration: const InputDecoration(
                  labelText: 'uso',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                enabled: false,
              ),

              const SizedBox(height: 10,),

              //campo de uso
              TextFormField(
                initialValue: context.tr('texts.doc_sinc.requisitos'),
                decoration: const InputDecoration(
                  labelText: 'Requisitos',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                enabled: false,
              ),

              const SizedBox(height: 20,),

              //campo de uso
              TextFormField(
                initialValue: "- ${context.tr('texts.doc_sinc.regla1')}\n"
                              "- ${context.tr('texts.doc_sinc.regla2')}\n"
                              "- ${context.tr('texts.doc_sinc.regla3')}\n",
                decoration: const InputDecoration(
                  labelText: 'Resolucion de conflictos',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                enabled: false,
              ),
              
              const SizedBox(height: 10,),

              //campo de uso
              TextFormField(
                initialValue: context.tr('texts.doc_sinc.limpieza'),
                decoration: const InputDecoration(
                  labelText: 'Limpieza',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                enabled: false,
              ),
            ],
          ),
          const SizedBox(height: 40,),
          const Footer(),
        ],
      )),
    );
  }
}