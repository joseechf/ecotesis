import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VisorPDF extends StatelessWidget {
  final String url;

  const VisorPDF({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visor PDF")),
      body: SfPdfViewer.network(url),
    );
  }
}
