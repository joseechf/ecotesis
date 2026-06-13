import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../iureutilizables/custom_appbar.dart';
import '../estilos.dart';
class VisorPDF extends StatelessWidget {
  final String url;
  const VisorPDF({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final isMobil = anchoPantalla < Estilos.cambioMenu;   
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobil ? const MobileMenu() : null,
      body: SfPdfViewer.network(url),
    ); 
  }
}