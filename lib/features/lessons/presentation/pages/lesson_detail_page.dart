// algonaid_mobail_app/lib/features/lessons/presentation/pages/lesson_detail_page.dart

import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  final int lessonId;

  const LessonDetailPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Detail $lessonId'),
      ),
      body: Center(
        child: Text('Details for Lesson ID: $lessonId'),
      ),
    );
  }
}
