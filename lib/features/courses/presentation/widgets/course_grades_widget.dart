import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/linearProgress.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/course_grades_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CourseGradesWidget extends StatefulWidget {
  final int courseId;

  const CourseGradesWidget({super.key, required this.courseId});

  @override
  State<CourseGradesWidget> createState() => _CourseGradesWidgetState();
}

class _CourseGradesWidgetState extends State<CourseGradesWidget> {
  late CourseGradesProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = getIt<CourseGradesProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.fetchGrades(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<CourseGradesProvider>(
        builder: (context, provider, child) {
          final state = provider.getState(widget.courseId);

          if (state.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  state.errorMessage!,
                  style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.grades == null || state.grades!.examDetails.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: context.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد اختبارات منجزة حالياً',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' لا توجد اختبارات لهذا الكورس بعد، كلما قمت بإنجاز اختبار سيتم عرض درجتك ونتيجتك هنا بالتفصيل.',
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final grades = state.grades!;
          final isUnlocked = grades.averagePercentage > 90;
          final isDark = context.theme.brightness == Brightness.dark;

          final unlockedGradient = isDark
              ? [const Color(0xFF423300), const Color(0xFF281F00)]
              : [Colors.amber.shade100, Colors.amber.shade50];

          final lockedGradient = isDark
              ? [context.surfaceContainer, context.surface]
              : [AppColors.grey200, AppColors.grey50];

          final unlockedTextColor = isDark ? Colors.amber.shade200 : Colors.amber.shade900;
          final lockedTextColor = isDark ? AppColors.grey300 : Colors.grey[800]!;
          final lockedSubTextColor = isDark ? AppColors.grey400 : Colors.grey[700]!;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Title
                  
                  const SizedBox(height: 24),

                  // Average & Cup Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isUnlocked ? unlockedGradient : lockedGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Cup / Lock Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUnlocked ? Colors.amber.shade400 : AppColors.grey400,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المعدل العام',
                                style: context.theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? unlockedTextColor : lockedTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isUnlocked ? 'رائع! لقد تم فك قفل وسام التفوق الذهبي.' : 'تحتاج إلى أكثر من 90% لفتح الوسام.',
                                style: context.theme.textTheme.bodySmall?.copyWith(
                                  color: isUnlocked ? unlockedTextColor : lockedSubTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Percentage
                        Text(
                          '${grades.averagePercentage.toStringAsFixed(1)}%',
                          style: context.theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? unlockedTextColor : lockedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Exams Section Title
                  Text(
                    'نتائج الاختبارات',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Exams List
                  ...grades.examDetails.map((exam) {
                    final isPerfect = exam.percentage == 100;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            final targetRoute = '${Routes.examPage}/${exam.examId}';
                            GoRouter.of(context).push(targetRoute, extra: Routes.coursesPage);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isPerfect
                                    ? (isDark ? Colors.green.shade700 : Colors.green.withOpacity(0.5))
                                    : (isDark ? Colors.transparent : AppColors.grey200),
                                width: isPerfect ? 2 : 1,
                              ),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.assignment_outlined,
                                            color: isPerfect ? Colors.green : context.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              exam.examTitle,
                                              style: context.theme.textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isPerfect
                                            ? (isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50)
                                            : (isDark ? context.primary.withOpacity(0.2) : context.primary.withOpacity(0.1)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${exam.highestScore} / ${exam.totalPoints}',
                                        style: context.theme.textTheme.labelMedium?.copyWith(
                                          color: isPerfect
                                              ? (isDark ? Colors.green.shade300 : Colors.green.shade700)
                                              : (isDark ? context.primary : context.primary),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgress(
                                        progressPercentage: exam.percentage,
                                        minHieght: 8,
                                        hPadding: 0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${exam.percentage.toStringAsFixed(0)}%',
                                      style: context.theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isPerfect ? Colors.green : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
