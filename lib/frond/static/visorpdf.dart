import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../iureutilizables/custom_appbar.dart';

class VisorPDF extends StatelessWidget {
  final String url;

  const VisorPDF({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: AppBar(title: Text("Visor PDF")),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SfPdfViewer.network(url),
    );
  }
}
