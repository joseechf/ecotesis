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
              Text(context.tr("titles.doc_sinc.Descipcion"),style: TextStyle(
                          color: Estilos.verdePrincipal,
                          fontFamily: 'Oswald',
                          fontSize: Estilos.textoMedio,
                          fontWeight: FontWeight.bold
                        ),),
              //campo de proposito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Estilos.verdePrincipal),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr('texts.doc_sinc.proposito')
                ),
              ),

              const SizedBox(height: 10,),

              //campo de uso
              Text(context.tr("titles.doc_sinc.uso"),style: TextStyle(
                          color: Estilos.verdePrincipal,
                          fontFamily: 'Oswald',
                          fontSize: Estilos.textoMedio,
                          fontWeight: FontWeight.bold
              ),),
              //campo de proposito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Estilos.verdePrincipal),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr('texts.doc_sinc.uso')
                ),
              ),

              const SizedBox(height: 10,),

              //campo de requisito
              Text(context.tr("titles.doc_sinc.Requisitos"),style: TextStyle(
                          color: Estilos.verdePrincipal,
                          fontFamily: 'Oswald',
                          fontSize: Estilos.textoMedio,
                          fontWeight: FontWeight.bold
              ),),
              //campo de proposito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Estilos.verdePrincipal),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr('texts.doc_sinc.requisitos')
                ),
              ),

              const SizedBox(height: 20,),

              //campo de uso
              Text(context.tr("titles.doc_sinc.conflictos"),style: TextStyle(
                          color: Estilos.verdePrincipal,
                          fontFamily: 'Oswald',
                          fontSize: Estilos.textoMedio,
                          fontWeight: FontWeight.bold
              ),),
              //campo de proposito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Estilos.verdePrincipal),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "- ${context.tr('texts.doc_sinc.regla1')}\n"
                  "- ${context.tr('texts.doc_sinc.regla2')}\n"
                  "- ${context.tr('texts.doc_sinc.regla3')}\n",
                ),
              ),
              
              const SizedBox(height: 10,),

              //campo de uso
              Text(context.tr("titles.doc_sinc.Limpieza"),style: TextStyle(
                          color: Estilos.verdePrincipal,
                          fontFamily: 'Oswald',
                          fontSize: Estilos.textoMedio,
                          fontWeight: FontWeight.bold
              ),),
              //campo de proposito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Estilos.verdePrincipal),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.tr('texts.doc_sinc.limpieza')
                ),
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