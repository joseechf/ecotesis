import 'package:flutter/material.dart';
import '../iureutilizables/custom_appbar.dart';
import '../iureutilizables/footer.dart';
import '../estilos.dart';
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('texts.doc_sinc.proposito')),
                const SizedBox(height: 10),

                Text(context.tr('texts.doc_sinc.uso')),
                const SizedBox(height: 10),

                Text(context.tr('texts.doc_sinc.requisitos')),
                const SizedBox(height: 20),

                Text(
                  context.tr('texts.doc_sinc.conflictos'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text("• ${context.tr('texts.doc_sinc.regla1')}"),
                Text("• ${context.tr('texts.doc_sinc.regla2')}"),
                Text("• ${context.tr('texts.doc_sinc.regla3')}"),
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
