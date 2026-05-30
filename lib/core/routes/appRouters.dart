import 'package:algonaid_mobail_app/auth_gate.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart'; // Import service_locator
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/circular_reveal.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/pages/signin_&_signup_pages.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/pages/courses_page.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/pages/courses_view_all_page.dart';
import 'package:algonaid_mobail_app/features/onboard/presentation/pages/onboarding_screen.dart'; // New Import
import 'package:algonaid_mobail_app/features/modules/presentation/pages/modules_list_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_detail_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lessons_list_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_intro_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:algonaid_mobail_app/features/search/presentation/pages/search_page.dart';
import 'package:algonaid_mobail_app/features/search/presentation/providers/search_courses_provider.dart';
import 'package:algonaid_mobail_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/pages/about_page.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/pages/developers_page.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/pages/settings_page.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/presentation/pages/all_excellence_courses_page.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/pages/all_badges_page.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/pages/policies_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';

abstract class AppRouters {
  /// The central router configuration for the application using [GoRouter].
  /// Handles navigation paths, transitions, and argument passing between screens.
  static final routers = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      /// Root route that acts as an authentication and initial load gatekeeper.
      /// Directs the user to the appropriate screen (e.g., Auth, Home, or Onboarding).
      GoRoute(path: '/', builder: (context, state) => AuthGate()),
      
      /// Onboarding route displayed to new users to introduce app features.
      GoRoute(
        path: Routes.onboarding, // New route
        builder: (context, state) => OnboardingScreen(),
      ),
      
      /// Main landing page containing the dashboard or user's courses.
      GoRoute(
        path: Routes.homePage,
        builder: (context, state) => const CoursesHomePage(),
      ),
      
      /// Alternate path explicitly pointing to the courses page.
      GoRoute(
        path: Routes.coursesPage,
        builder: (context, state) => const CoursesHomePage(),
      ),

      /// Search page for courses.
      GoRoute(
        path: Routes.searchPage,
        builder: (context, state) => ChangeNotifierProvider.value(
          value: getIt<SearchCoursesProvider>(),
          child: const SearchPage(),
        ),
      ),
      
      /// Notifications page.
      GoRoute(
        path: Routes.notificationsPage,
        builder: (context, state) => const NotificationsPage(),
      ),
      
      /// Authentication route (Sign In & Sign Up).
      /// Uses a custom [GreenRevealPage] page builder for a circular reveal transition effect.
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
      
      /// Displays a list of modules for a specific course.
      /// Expects a [CourseEntity] object to be passed as `state.extra`.
      GoRoute(
        path: '${Routes.modulesList}/:courseId',
        builder: (context, state) {
          final data = state.extra as CourseEntity;

          return ModulesListPage(course: data);
        },
      ),
      
      /// Displays a list of lessons within a specific module.
      /// Extracts `moduleId` from path parameters and optional metadata from `state.extra`.
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
      
      /// Displays the details and content of a specific lesson (e.g., Video, PDF).
      /// Extracts `lessonId` from path parameters and an optional previous route from `state.extra`.
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
      
      /// Displays the introduction or starting page for a specific exam.
      /// Injects the [ExamProvider] so that the exam context is available to the widget tree.
      GoRoute(
        path: '${Routes.examPage}/:examId',
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          final previousRoute = state.extra is String
              ? state.extra as String
              : null;
          debugPrint(
            'AppRouters: building exam route, location=${state.uri}, examId=$examId',
          );
          return ChangeNotifierProvider.value(
            value: getIt<ExamProvider>(),
            child: ExamIntroPage(examId: examId, previousRoute: previousRoute),
          );
        },
      ),
      
      /// About the platform page.
      GoRoute(
        path: Routes.aboutPage,
        builder: (context, state) => const AboutPage(),
      ),
      
      /// About the developers page.
      GoRoute(
        path: Routes.developersPage,
        builder: (context, state) => const DevelopersPage(),
      ),
      
      /// Settings page.
      GoRoute(
        path: Routes.settingsPage,
        builder: (context, state) => const SettingsPage(),
      ),
      
      /// All Excellence Courses page.
      GoRoute(
        path: Routes.allExcellenceCourses,
        builder: (context, state) => const AllExcellenceCoursesPage(),
      ),
      /// Policies page.
      GoRoute(
        path: Routes.policiesPage,
        builder: (context, state) => const PoliciesPage(),
      ),
      /// View all courses page
      GoRoute(
        path: Routes.coursesViewAllPage,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return CoursesViewAllPage(
            title: data?['title'] as String? ?? 'الدورات',
            courses: data?['courses'] as List<CourseEntity>? ?? [],
          );
        },
      ),
      /// All badges page
      GoRoute(
        path: Routes.allBadgesPage,
        builder: (context, state) => const AllBadgesPage(),
      ),
    ],
  );
}
