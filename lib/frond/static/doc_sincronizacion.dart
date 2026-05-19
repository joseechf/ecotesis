import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import '../iureutilizables/footer.dart';
import 'package:easy_localization/easy_localization.dart';

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
                // Campo de propósito
                TextFormField(
                  initialValue: context.tr('texts.doc_sinc.proposito'),
                  decoration: const InputDecoration(
                    labelText: 'Propósito',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: false,
                ),

                const SizedBox(height: 10),

                // Campo de uso
                TextFormField(
                  initialValue: context.tr('texts.doc_sinc.uso'),
                  decoration: const InputDecoration(
                    labelText: 'Uso',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: false,
                ),

                const SizedBox(height: 10),

                // Campo de requisitos
                TextFormField(
                  initialValue: context.tr('texts.doc_sinc.requisitos'),
                  decoration: const InputDecoration(
                    labelText: 'Requisitos',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: false,
                ),

                const SizedBox(height: 20),

                // Campo de resolución de conflictos
                TextFormField(
                  initialValue:
                      "• ${context.tr('texts.doc_sinc.regla1')}\n"
                      "• ${context.tr('texts.doc_sinc.regla2')}\n"
                      "• ${context.tr('texts.doc_sinc.regla3')}",
                  decoration: const InputDecoration(
                    labelText: 'Resolución de conflictos',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: false,
                ),

                const SizedBox(height: 10),

                // Campo de limpieza
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

            const SizedBox(height: 40),

            // Pie de página
            const Footer(),
          ],
        ),
      ),
    );
  }
}
