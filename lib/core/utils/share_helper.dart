import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static const String _baseUrl = 'https://api.exchangesmangement.online';

  static String _cleanAndShortenMarkdown(String? text) {
    if (text == null || text.isEmpty) return '';
    // إزالة الرموز الخاصة بـ Markdown
    String cleanText = text.replaceAll(RegExp(r'[#*_~`\[\]]'), '');
    // إزالة المسافات والأسطر الزائدة
    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleanText.length > 150) {
      return '${cleanText.substring(0, 150)}...';
    }
    return cleanText;
  }

  /// Shares a course link with motivational text
  static Future<void> shareCourse(CourseEntity course) async {
    final link = '$_baseUrl/modulesList/${course.id}';
    final cleanDesc = _cleanAndShortenMarkdown(course.description);
    final descText = cleanDesc.isNotEmpty ? '\n$cleanDesc\n' : '';
    
    final text = '''
مرحباً، أنصحك بالانضمام وتجربة هذا المقرر الرائع "${course.title}" على تطبيق الجنيد.
$descText
يمكنك البدء والمشاركة عبر هذا الرابط:
$link
'''.trim();

    await Share.share(text, subject: course.title);
  }

  /// Shares a lesson link with motivational text
  static Future<void> shareLesson(LessonDetail lesson, {String? courseName, String? moduleName, String? instructorName}) async {
    final link = '$_baseUrl/lessonDetails/${lesson.id}';
    
    String contextText = '';
    if (moduleName != null && courseName != null) {
      contextText = ' في وحدة "$moduleName" ضمن مقرر "$courseName"';
    } else if (courseName != null) {
      contextText = ' ضمن مقرر "$courseName"';
    } else if (moduleName != null) {
      contextText = ' ضمن وحدة "$moduleName"';
    }
    
    final instructorText = instructorName != null ? ' بتقديم المدرب "$instructorName"' : '';

    final text = '''
أهلاً بك، وجدت درساً قيماً بعنوان "${lesson.title}"$contextText$instructorText على تطبيق الجنيد، وأحببت أن أشاركه معك لتستفيد منه.

بادر بالانضمام واستفد من المحتوى عبر الرابط التالي:
$link
'''.trim();

    await Share.share(text, subject: lesson.title);
  }

  /// Shares a badge achievement with motivational text
  static Future<void> shareBadge(String badgeTitle, {String? courseName, String? moduleName, int? courseId}) async {
    final link = courseId != null ? '$_baseUrl/courses/$courseId' : _baseUrl;
    
    String contextText = '';
    if (moduleName != null && courseName != null) {
      contextText = ' في وحدة "$moduleName" ضمن مقرر "$courseName"';
    } else if (courseName != null) {
      contextText = ' في مقرر "$courseName"';
    } else if (moduleName != null) {
      contextText = ' في وحدة "$moduleName"';
    }

    final text = '''
لقد حققت إنجازاً رائعاً وحصلت على "$badgeTitle"$contextText على منصة الجنيد! 🏆

انضم إلي وابدأ رحلة التعلم الممتعة:
$link
'''.trim();

    await Share.share(text, subject: 'إنجاز جديد في منصة الجنيد');
  }
}
