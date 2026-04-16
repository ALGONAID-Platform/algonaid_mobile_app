// algonaid_mobail_app/lib/features/modules/domain/entities/module.dart

import 'package:equatable/equatable.dart';

class Module extends Equatable {
  final int id;
  final String title;
  final String description;
  final int courseId;
  final int order;

  const Module({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.order,
  });

  @override
  List<Object?> get props => [id, title, description, courseId, order];
}
