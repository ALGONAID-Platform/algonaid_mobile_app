/// كيان دورة في طبقة المجال (خالٍ من تفاصيل الـ API).
class Course {
  const Course({
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
}

/// ملخص الدورة الحالية لقسم «تابع التعلم».
class ContinueLearningCourse {
  const ContinueLearningCourse({
    required this.title,
    required this.description,
    required this.progress,
    required this.imageUrl,
    required this.subjectTag,
    required this.timeRemaining,
    required this.lessonPosition,
    required this.progressCaption,
  });

  final String title;
  final String description;
  /// بين ٠ و ١
  final double progress;
  final String imageUrl;
  final String subjectTag;
  final String timeRemaining;
  final String lessonPosition;
  final String progressCaption;
}
