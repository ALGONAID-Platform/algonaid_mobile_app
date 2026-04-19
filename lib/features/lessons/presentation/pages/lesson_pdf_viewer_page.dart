import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LessonPdfViewerPage extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const LessonPdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppColors.primary),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
      ),
    );
  }
}
