import 'package:algonaid/auth_gate.dart';
import 'package:algonaid/core/di/service_locator.dart'; // Import service_locator
import 'package:algonaid/core/routes/navigatorKey.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/widgets/shared/circular_reveal.dart';
import 'package:algonaid/features/auth/presentation/pages/signin_&_signup_pages.dart';
import 'package:algonaid/features/auth/presentation/pages/email_verification_page.dart';
import 'package:algonaid/features/auth/presentation/pages/email_verified_success_page.dart';
import 'package:algonaid/features/auth/presentation/pages/email_verify_failed_page.dart';
import 'package:algonaid/features/auth/presentation/pages/reset_password_page.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/courses/domain/entities/teacher_entity.dart';
import 'package:algonaid/features/courses/domain/entities/user_entity.dart';
import 'package:algonaid/features/courses/presentation/pages/courses_page.dart';
import 'package:algonaid/features/courses/presentation/pages/courses_view_all_page.dart';
import 'package:algonaid/features/courses/presentation/pages/guest_courses_page.dart';
import 'package:algonaid/features/modules/presentation/pages/modules_list_page.dart';
import 'package:algonaid/features/lesson_detail/presentation/pages/lesson_detail_page.dart';
import 'package:algonaid/features/lessons/presentation/pages/lessons_list_page.dart';
import 'package:algonaid/features/exams/presentation/pages/exam_intro_page.dart';
import 'package:algonaid/features/exams/presentation/providers/exam_provider.dart';
import 'package:algonaid/features/search/presentation/pages/search_page.dart';
import 'package:algonaid/features/search/presentation/providers/search_courses_provider.dart';
import 'package:algonaid/features/notifications/presentation/pages/notifications_page.dart';
import 'package:algonaid/features/settings/presentation/pages/about_page.dart';
import 'package:algonaid/features/settings/presentation/pages/about_teacher_page.dart';
import 'package:algonaid/features/settings/presentation/pages/developers_page.dart';
import 'package:algonaid/features/settings/presentation/pages/settings_page.dart';
import 'package:algonaid/features/excellence_courses/presentation/pages/all_excellence_courses_page.dart';
import 'package:algonaid/features/profile/presentation/pages/all_badges_page.dart';
import 'package:algonaid/features/settings/presentation/pages/policies_page.dart';
import 'package:algonaid/features/onboard/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static final Map<ValueKey<String>, Offset> _routeOffsetCache = {};

  static Offset? _consumeOffset(GoRouterState state) {
    final pageKey = state.pageKey;
    if (_routeOffsetCache.containsKey(pageKey)) {
      return _routeOffsetCache[pageKey];
    }

    Offset? offset;
    final extra = state.extra;
    if (extra is Offset) {
      offset = extra;
    } else if (extra is Map<String, dynamic> && extra['offset'] is Offset) {
      offset = extra['offset'] as Offset;
    }
    offset ??= RevealOffsetTracker.lastTapOffset;
    RevealOffsetTracker.lastTapOffset = null;

    if (offset != null) {
      _routeOffsetCache[pageKey] = offset;
    }

    // Clean up cache to prevent memory leaks
    if (_routeOffsetCache.length > 10) {
      _routeOffsetCache.remove(_routeOffsetCache.keys.first);
    }

    return offset;
  }

  /// The central router configuration for the application using [GoRouter].
  /// Handles navigation paths, transitions, and argument passing between screens.
  static final routers = GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) {
      // If the incoming location is a full URL (deep link), strip the domain
      if (state.uri.host.isNotEmpty) {
        return state.uri.path + (state.uri.hasQuery ? '?${state.uri.query}' : '');
      }
      return null;
    },
    routes: [
      /// Root route that acts as an authentication and initial load gatekeeper.
      /// Directs the user to the appropriate screen (e.g., Auth, Home, or Onboarding).
      GoRoute(path: '/', builder: (context, state) => AuthGate()),

      /// Onboarding page
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => OnboardingScreen(),
      ),

      /// Main landing page containing the dashboard or user's courses.
      GoRoute(
        path: Routes.homePage,
        pageBuilder: (context, state) {
          Offset? centerOffset = _consumeOffset(state);

          if (centerOffset == null) {
            final size = MediaQuery.of(context).size;
            centerOffset = Offset(size.width / 2, size.height / 2);
          }

          return GreenRevealPage(
            key: state.pageKey,
            child: const CoursesHomePage(),
            center: centerOffset,
            color: AppColors.primary,
          );
        },
      ),

      /// Guest landing page containing the courses in grid view without login.
      GoRoute(
        path: Routes.guestHome,
        pageBuilder: (context, state) {
          Offset? centerOffset = _consumeOffset(state);

          if (centerOffset == null) {
            final size = MediaQuery.of(context).size;
            centerOffset = Offset(size.width / 2, size.height / 2);
          }

          return GreenRevealPage(
            key: state.pageKey,
            child: const GuestHomePage(),
            center: centerOffset,
            color: AppColors.primary,
          );
        },
      ),

      /// Alternate path explicitly pointing to the courses page.
      GoRoute(
        path: Routes.coursesPage,
        pageBuilder: (context, state) {
          Offset? centerOffset = _consumeOffset(state);

          if (centerOffset == null) {
            final size = MediaQuery.of(context).size;
            centerOffset = Offset(size.width / 2, size.height / 2);
          }

          return GreenRevealPage(
            key: state.pageKey,
            child: const CoursesHomePage(),
            center: centerOffset,
            color: AppColors.primary,
          );
        },
      ),

      /// Search page for courses.
      GoRoute(
        path: Routes.searchPage,
        builder: (context, state) => const SearchPage(),
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
          Offset? centerOffset = _consumeOffset(state);

          if (centerOffset == null) {
            final size = MediaQuery.of(context).size;
            final topPadding = MediaQuery.of(context).padding.top;
            final isRtl = Directionality.of(context) == TextDirection.rtl;
            final x = isRtl ? 80.0 : (size.width - 80.0);
            final y = topPadding + 56.0 / 2; // Center of the AppBar
            centerOffset = Offset(x, y);
          }

          return GreenRevealPage(
            key: state.pageKey,
            child: const SigninAndSignupPage(),
            center: centerOffset,
            color: AppColors.primary,
          );
        },
      ),

      /// Dummy route for deep linking email verification
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),

      /// Email Verification Page
      GoRoute(
        path: Routes.emailVerification,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return EmailVerificationPage(email: email);
        },
      ),

      /// Email Verified Success Page
      GoRoute(
        path: Routes.emailVerifiedSuccess,
        builder: (context, state) => const EmailVerifiedSuccessPage(),
      ),

      /// Email Verify Failed Page
      GoRoute(
        path: Routes.emailVerifyFailed,
        builder: (context, state) {
          final message = state.extra as String?;
          return EmailVerifyFailedPage(message: message);
        },
      ),

      /// Reset Password Page
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) {
          final token = state.extra as String? ?? '';
          return ResetPasswordPage(token: token);
        },
      ),

      /// Displays a list of modules for a specific course.
      /// Expects a [CourseEntity] object to be passed as `state.extra` (optional fallback to ID lookup).
      GoRoute(
        path: '${Routes.modulesList}/:courseId',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          CourseEntity? data = state.extra as CourseEntity?;

          if (data == null) {
            try {
              final provider = Provider.of<GetCoursesProvider>(context, listen: false);
              data = provider.myCourses.firstWhere(
                (c) => c.id == courseId,
                orElse: () => provider.allCourses.firstWhere((c) => c.id == courseId),
              );
            } catch (_) {}
          }

          data ??= CourseEntity(
              id: courseId,
              title: 'جاري تحميل الدورة...',
              description: '',
              thumbnail: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              instructorId: 0,
              moduleTitles: [],
              modulesCount: 0,
              isEnrolled: true,
              totalLessons: 0,
              completedLessons: 0,
              progressPercentage: 0.0,
              teacher: TeacherEntity(
                id: 0,
                specialization: '',
                experience: 0,
                userId: 0,
                user: UserEntity(name: '', email: ''),
              ),
            );

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
            courseId: (data?['courseId'] as num?)?.toInt(),
            moduleDescription: data?['moduleDescription'] as String?,
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

      /// About teacher page
      GoRoute(
        path: Routes.aboutTeacherPage,
        builder: (context, state) => const AboutTeacherPage(),
      ),
    ],
  );
}
