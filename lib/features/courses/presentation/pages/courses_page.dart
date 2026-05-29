import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/all_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/bottomNavigationBar.dart';

import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildShimmerSection.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/courseHeader.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/my_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/pages/profile_page.dart'; // Added
import 'package:algonaid_mobail_app/features/downloads/presentation/pages/downloads_page.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/pages/competitions_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCoursesProvider>().refreshAll();
      context.read<LastAccessedModuleProvider>().fetchLastAccessedModule();
    });
    debugPrint('User Token on CoursesPage init: ${TokenStorage.getToken()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: RefreshIndicator(
        elevation: 0.0,

        onRefresh: () async {
          await context.read<GetCoursesProvider>().refreshAll();
          await context
              .read<LastAccessedModuleProvider>()
              .fetchLastAccessedModule();
        },
        color: AppColors.primary,
        child: Consumer<GetCoursesProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SectionHeader(text: 'اخر باب')),
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
                        courseHeader(),

                        MyCoursesListSection(myCourses: provider.myCourses),

                        AllCoursesListSection(allCourses: provider.allCourses),

                        const SizedBox(height: 100),
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

  List<Widget> get _pages => const [
    CoursesPage(key: ValueKey('home')), // الصفحة الرئيسية
    CompetitionsPage(key: ValueKey('competitions')), // المسابقات
    DownloadsPage(key: ValueKey('bookmarks')), // المحفوظات والتحميلات
    ProfilePage(key: ValueKey('profile')), // الحساب
  ];

  Future<void> _logout() async {
    await context.read<AuthServiceProvider>().logout();
    if (!mounted) {
      return;
    }
    context.go(Routes.auth);
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'الصفحة الرئيسية';
      case 1:
        return 'المسابقات والتحديات';
      case 2:
        return ' الدروس المحفوظة';
      case 3:
        return 'الملف الشخصي';
      default:
        return 'الرئيسية';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        CacheHelper.getString(key: AppConstants.userName) ?? 'مستخدم';
    final userEmail = CacheHelper.getString(key: AppConstants.userEmail) ?? '';
    final userAvatar = CacheHelper.getString(key: AppConstants.userAvatar);

    return Scaffold(
      backgroundColor: context.background,
      appBar: CustomWhiteAppBar(
        userName: userName,
        userImageUrl: userAvatar,
        appBarTitle: _getAppBarTitle(_currentIndex),
        notificationCount: 4,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onProfilePressed: () {
          setState(() {
            _currentIndex = 3;
          });
        },
        onNotificationPressed: () {
          context.push(Routes.notificationsPage);
        },
        onSearchPressed: () {
          context.push(Routes.searchPage);
        },
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _pages[_currentIndex],
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FancyFloatingNavBar(
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
