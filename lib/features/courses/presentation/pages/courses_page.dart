import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/all_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/bottomNavigationBar.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildShimmerSection.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/courseHeader.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/my_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/continue_learning_card.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/pages/profile_page.dart'; // Added

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

                        const SizedBox(height: 50),
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
  int _currentIndex = 0;

  List<Widget> get _pages => const [
    CoursesPage(key: ValueKey('home')), // الصفحة الرئيسية
    Placeholder(key: ValueKey('courses')), // الدورات
    Placeholder(key: ValueKey('bookmarks')), // المحفوظات
    ProfilePage(key: ValueKey('profile')), // الحساب
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,

      appBar: CustomWhiteAppBar(
        userName: CacheHelper.getString(key: AppConstants.userName) ?? "مستخدم",
        userImageUrl: null,
        notificationCount: 4,
        onProfilePressed: () {},
        onNotificationPressed: () {},
        onSearchPressed: () {},
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _pages[_currentIndex],
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
      ),
      extendBody: true, // مهم لكي يظهر البار عائم!
      bottomNavigationBar: FancyFloatingNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
