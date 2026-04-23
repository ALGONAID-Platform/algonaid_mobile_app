import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class LessonModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String content;
  
  @HiveField(4)
  final String? videoUrl;
  
  @HiveField(5)
  final String? pdfUrl;
  
  @HiveField(6)
  final int order;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.videoUrl,
    this.pdfUrl,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      videoUrl: json['videoUrl'],
      pdfUrl: json['pdfUrl'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'content': content,
    'videoUrl': videoUrl,
    'pdfUrl': pdfUrl,
    'order': order,
  };
}