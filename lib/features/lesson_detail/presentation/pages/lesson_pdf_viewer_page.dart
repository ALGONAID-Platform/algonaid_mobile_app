import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:algonaid_mobail_app/core/widgets/shared/shared_app_bar.dart';

class LessonPdfViewerPage extends StatelessWidget {
  final String? pdfUrl;
  final String? localPdfPath;
  final String title;

  const LessonPdfViewerPage({
    super.key,
    this.pdfUrl,
    this.localPdfPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget pdfViewer;
    if (localPdfPath != null && File(localPdfPath!).existsSync()) {
      pdfViewer = SfPdfViewer.file(
        File(localPdfPath!),
        canShowPaginationDialog: true,
        canShowScrollHead: true,
      );
    } else if (pdfUrl != null) {
      pdfViewer = SfPdfViewer.network(
        pdfUrl!,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
      );
    } else {
      pdfViewer = const Center(child: Text('PDF غير متوفر'));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: SharedAppBar(
          title: title,
        ),
        body: pdfViewer,
      ),
    );
  }
}
