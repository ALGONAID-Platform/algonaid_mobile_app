class ContinueLearningModel {
  const ContinueLearningModel({
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
  final double progress;
  final String imageUrl;
  final String subjectTag;
  final String timeRemaining;
  final String lessonPosition;
  final String progressCaption;

  factory ContinueLearningModel.fromJson(Map<String, dynamic> json) {
    final p = json['progress'];
    double progress = 0;
    if (p is num) {
      progress = p.toDouble();
    } else if (p is String) {
      progress = double.tryParse(p) ?? 0;
    }
    if (progress > 1) {
      progress = progress / 100;
    }
    return ContinueLearningModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      progress: progress.clamp(0.0, 1.0),
      imageUrl:
          json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      subjectTag:
          json['subject_tag'] as String? ?? json['subjectTag'] as String? ?? '',
      timeRemaining:
          json['time_remaining'] as String? ??
          json['timeRemaining'] as String? ??
          '',
      lessonPosition:
          json['lesson_position'] as String? ??
          json['lessonPosition'] as String? ??
          '',
      progressCaption:
          json['progress_caption'] as String? ??
          json['progressCaption'] as String? ??
          '',
    );
  }

  // ContinueLearningCourse toEntity() => ContinueLearningCourse(
  //       title: title,
  //       description: description,
  //       progress: progress,
  //       imageUrl: imageUrl,
  //       subjectTag: subjectTag,
  //       timeRemaining: timeRemaining,
  //       lessonPosition: lessonPosition,
  //       progressCaption: progressCaption,
  //     );
}
