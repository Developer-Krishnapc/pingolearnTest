import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../core/extension/widget.dart';
import '../../design/components/sample_pages_app_bar.dart';

@RoutePage()
class PdfViewPage extends StatelessWidget {
  const PdfViewPage({
    super.key,
    required this.filePath,
    required this.fileName,
  });
  final String filePath;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SamplePageAppBar(
              title: fileName,
            ),
            Expanded(
              child: PDFView(
                filePath: filePath,
              ),
            ),
          ],
        ).padHor(15),
      ),
    );
  }

  Future<void> _printPdf() async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => bytes,
    );
  }
}
