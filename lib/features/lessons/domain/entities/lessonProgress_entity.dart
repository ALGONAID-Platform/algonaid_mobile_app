class LessonProgress {
  final int id;
  final bool isCompleted;
  final DateTime? completedAt;
  final int studentId;
  final int lessonId;

  const LessonProgress({
    required this.id,
    required this.isCompleted,
    this.completedAt,
    required this.studentId,
    required this.lessonId,
  });
}

