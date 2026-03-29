import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import '../iureutilizables/footer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../iureutilizables/widget_edicion.dart';

class ExplicacionSincronizacion extends StatelessWidget {
  const ExplicacionSincronizacion({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              children: [
                CampoTextoPersonalizado(
                  controlador: TextEditingController(
                    text: context.tr('texts.doc_sinc.proposito'),
                  ),
                  etiqueta: 'Propósito',
                  maxLineas: null,
                  habilitado: false,
                ),

                const SizedBox(height: 10),

                CampoTextoPersonalizado(
                  controlador: TextEditingController(
                    text: context.tr('texts.doc_sinc.uso'),
                  ),
                  etiqueta: 'Uso',
                  maxLineas: null,
                  habilitado: false,
                ),

                const SizedBox(height: 10),

                CampoTextoPersonalizado(
                  controlador: TextEditingController(
                    text: context.tr('texts.doc_sinc.requisitos'),
                  ),
                  etiqueta: 'Requisitos',
                  maxLineas: null,
                  habilitado: false,
                ),

                const SizedBox(height: 20),

                CampoTextoPersonalizado(
                  controlador: TextEditingController(
                    text:
                        "• ${context.tr('texts.doc_sinc.regla1')}\n"
                        "• ${context.tr('texts.doc_sinc.regla2')}\n"
                        "• ${context.tr('texts.doc_sinc.regla3')}",
                  ),
                  etiqueta: 'Resolución de conflictos',
                  maxLineas: null,
                  habilitado: false,
                ),

                const SizedBox(height: 10),

                CampoTextoPersonalizado(
                  controlador: TextEditingController(
                    text: context.tr('texts.doc_sinc.limpieza'),
                  ),
                  etiqueta: 'Limpieza',
                  maxLineas: null,
                  habilitado: false,
                ),
              ],
            ),

            const SizedBox(height: 40),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
