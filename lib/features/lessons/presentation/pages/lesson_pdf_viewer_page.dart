import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io'; // Import for File

class LessonPdfViewerPage extends StatelessWidget {
  final String? pdfUrl; // Made nullable
  final String? localPdfPath; // New parameter
  final String title;

  const LessonPdfViewerPage({
    super.key,
    this.pdfUrl, // Made optional
    this.localPdfPath, // New optional parameter
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
      // Handle case where neither URL nor local path is available
      pdfViewer = const Center(child: Text('PDF غير متوفر'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppColors.primary),
      body: pdfViewer,
    );
  }
}
