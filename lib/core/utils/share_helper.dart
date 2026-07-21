import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static const String _baseUrl = 'https://algonaid-api.onrender.com';

  /// Shares a course link with motivational text
  static Future<void> shareCourse(CourseEntity course) async {
    final link = '$_baseUrl/modulesList/${course.id}';
    final text = '''
✨ انضم إلي في تعلم مهارات جديدة! ✨

أنا أدرس كورس "${course.title}" على منصة الجنيد.
${course.description}

ابدأ رحلة التعلم معي الآن عبر هذا الرابط:
$link
''';

    await Share.share(text, subject: course.title);
  }

  /// Shares a lesson link with motivational text
  static Future<void> shareLesson(LessonDetail lesson, {String? courseName}) async {
    final link = '$_baseUrl/lessonDetails/${lesson.id}';
    final courseText = courseName != null ? ' ضمن كورس "$courseName"' : '';
    final text = '''
🚀 درس مفيد جداً يستحق المشاهدة!

أنا حالياً أتعلم درس "${lesson.title}"$courseText على منصة الجنيد.
${lesson.description}

بإمكانك مشاهدته من خلال هذا الرابط:
$link
''';

    await Share.share(text, subject: lesson.title);
  }
}
