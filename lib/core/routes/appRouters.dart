import 'package:algonaid_mobail_app/auth_gate.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart'; // Import service_locator
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/circular_reveal.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/pages/signin_&_signup_pages.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/pages/courses_page.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/pages/onboarding_screen.dart'; // New Import
import 'package:algonaid_mobail_app/features/courses/presentation/pages/courses_page.dart'; // New Import
import 'package:algonaid_mobail_app/features/modules/presentation/pages/modules_list_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_detail_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lessons_list_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_intro_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart'; // Add this import

import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static final routers = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: '/', builder: (context, state) => AuthGate()),
      GoRoute(
        path: Routes.onboarding, // New route
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.homePage,
        builder: (context, state) => const CoursesHomePage(),
      ),
      GoRoute(
        path: Routes.coursesPage,
        builder: (context, state) => const CoursesHomePage(),
      ),
      GoRoute(
        path: Routes.auth,
        pageBuilder: (context, state) {
          final size = MediaQuery.of(context).size;
          return GreenRevealPage(
            key: state.pageKey,
            child: const SigninAndSignupPage(),
            center: Offset(size.width - 50, size.height - 70),
            color: AppColors.primary,
          );
        },
      ),
      GoRoute(
        path: '${Routes.modulesList}/:courseId',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);

          final data = state.extra as CourseEntity;

          return ModulesListPage(course: data);
        },
      ),
      GoRoute(
        path: '${Routes.lessonsList}/:moduleId',
        builder: (context, state) {
          final moduleId = int.parse(state.pathParameters['moduleId']!);
          final data = state.extra as Map<String, dynamic>?;

          return LessonsListPage(
            moduleId: moduleId,
            moduleTitle: data?['moduleTitle'] as String? ?? 'تفاصيل الوحدة',
            completedLessons: (data?['completedLessons'] as num?)?.toInt() ?? 0,
            progressPercentage:
                (data?['progressPercentage'] as num?)?.toDouble() ?? 0.0,
            totalLessons: (data?['totalLessons'] as num?)?.toInt() ?? 0,
          );
        },
      ),
      GoRoute(
        path: '${Routes.lessonDetails}/:lessonId',
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          final previousRoute = state.extra is String
              ? state.extra as String
              : null;
          return LessonDetailPage(
            lessonId: lessonId,
            previousRoute: previousRoute,
          );
        },
      ),
      GoRoute(
        path: '${Routes.examPage}/:examId',
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          debugPrint(
            'AppRouters: building exam route, location=${state.uri}, examId=$examId',
          );
          return ChangeNotifierProvider.value(
            value: getIt<ExamProvider>(),
            child: ExamIntroPage(examId: examId),
          );
        },
      ),
    ],
  );
}
