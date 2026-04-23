import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/all_courses_section.dart';

import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildShimmerSection.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/my_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/continue_learning_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند تشغيل الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCoursesProvider>().refreshAll();
    });
    debugPrint('User Token on CoursesPage init: ${TokenStorage.getToken()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => context.read<GetCoursesProvider>().refreshAll(),
        color: AppColors.primary,
        child: Consumer<GetCoursesProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if (provider.isLoading)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const ContinueLearningShimmer(),
                        const SizedBox(height: 20),
                        CoursesSectionShimmer(),
                        const SizedBox(height: 20),
                        CoursesSectionShimmer(),
                      ],
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        if (provider.myCourses.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ContinueLearningCard(),
                          ),

                        MyCoursesListSection(myCourses: provider.myCourses),

                        AllCoursesListSection(allCourses: provider.allCourses),

                        const SizedBox(height: 50), // مسافة في النهاية
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class CoursesHomePage extends StatefulWidget {
  const CoursesHomePage({Key? key}) : super(key: key);

  @override
  State<CoursesHomePage> createState() => _CoursesHomePageState();
}

class _CoursesHomePageState extends State<CoursesHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final _pages = [
    const CoursesPage(),
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
  ];

  Future<void> _logout() async {
    await context.read<AuthServiceProvider>().logout();
    if (!mounted) {
      return;
    }
    context.go(Routes.auth);
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        CacheHelper.getString(key: AppConstants.userName) ?? 'مستخدم';
    final userEmail = CacheHelper.getString(key: AppConstants.userEmail) ?? '';

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 260,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (userEmail.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('تسجيل الخروج'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      appBar: CustomWhiteAppBar(
        userName: userName,
        userImageUrl: null,
        notificationCount: 4,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onProfilePressed: () {},
        onNotificationPressed: () {},
        onSearchPressed: () {
          debugPrint(TokenStorage.getToken());
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _pages[_currentIndex],
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
      ),

    );
  }
}
