// algonaid_mobail_app/lib/features/lessons/domain/entities/lesson.dart

import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;
  final int moduleId;
  final int order;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    required this.moduleId,
    required this.order,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    videoUrl,
    pdfUrl,
    moduleId,
    order,
  ];
}
