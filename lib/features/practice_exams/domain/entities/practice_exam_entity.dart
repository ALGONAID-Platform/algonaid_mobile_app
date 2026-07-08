class PracticeExamEntity {
  final int id;
  final String title;
  final String description;
  final String pdfUrl;
  final String grade;
  final int courseId;
  final DateTime createdAt;

  PracticeExamEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.pdfUrl,
    required this.grade,
    required this.courseId,
    required this.createdAt,
  });
}
