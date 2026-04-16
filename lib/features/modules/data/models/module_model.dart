// algonaid_mobail_app/lib/features/modules/data/models/module_model.dart

import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';

class ModuleModel extends Module {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.courseId,
    required super.order,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      courseId: json['courseId'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'order': order,
    };
  }
}
