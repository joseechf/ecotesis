import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'iureutilizables/custom_appbar.dart' as app_bar;

class VisorPDF extends StatelessWidget {
  final String url;

  const VisorPDF({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: AppBar(title: Text("Visor PDF")),
      endDrawer: isMobile ? app_bar.MobileMenu() : null,
      body: SfPdfViewer.network(url),
    );
  }
}
