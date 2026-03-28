class Lesson {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final int order;
  final String? videoUrl;

  const Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    this.description,
    this.videoUrl,
  });
}
