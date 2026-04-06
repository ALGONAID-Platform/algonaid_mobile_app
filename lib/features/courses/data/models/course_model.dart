import 'package:algonaid_mobail_app/features/courses/domain/entities/course.dart';

class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.imageOverlayTitle,
    required this.availabilityLine,
    required this.tags,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String imageOverlayTitle;
  final String availabilityLine;
  final List<String> tags;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final tagsJson = json['tags'];
    return CourseModel(
      id: '${json['id'] ?? ''}',
      title: json['title'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      imageOverlayTitle: json['image_overlay_title'] as String? ??
          json['imageOverlayTitle'] as String? ??
          '',
      availabilityLine:
          json['availability_line'] as String? ?? json['availabilityLine'] as String? ?? '',
      tags: tagsJson is List
          ? tagsJson.map((e) => '$e').toList()
          : const <String>[],
    );
  }

  Course toEntity() => Course(
        id: id,
        title: title,
        imageUrl: imageUrl,
        imageOverlayTitle: imageOverlayTitle,
        availabilityLine: availabilityLine,
        tags: tags,
      );
}
