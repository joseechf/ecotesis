import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../iureutilizables/custom_appbar.dart';

class VisorPDF extends StatelessWidget {
  final String url;

  const VisorPDF({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visor PDF")),
      drawer:
          MediaQuery.sizeOf(context).width < 800 ? const MobileMenu() : null,
      body: SfPdfViewer.network(url),
    );
  }
}
