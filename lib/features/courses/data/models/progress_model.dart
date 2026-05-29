import 'package:hive/hive.dart';

@HiveType(typeId: 6)
class ProgressModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final bool isCompleted;
  
  @HiveField(2)
  final DateTime? completedAt;

  ProgressModel({
    required this.id,
    required this.isCompleted,
    this.completedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };
}