import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../iureutilizables/custom_appbar.dart';

class VisorPDF extends StatelessWidget {
  final String url;

  const VisorPDF({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    return Scaffold(
      appBar: CustomAppBar(context: context),
      drawer: isMobile ? const MobileMenu() : null,
      body: SfPdfViewer.network(url),
    );
  }
}
