import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/all_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/bottomNavigationBar.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildShimmerSection.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/my_courses_section.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  final _pages = [
    CoursesPage(), // الصفحة الرئيسية
    Placeholder(), // الدورات
    Placeholder(), // المحفوظات
    Placeholder(), // الحساب
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWhiteAppBar(
        userName: CacheHelper.getString(key: AppConstants.userName) ?? "مستخدم",
        userImageUrl: null,
        notificationCount: 4,
        onProfilePressed: () {},
        onNotificationPressed: () {
         
        },
        onSearchPressed: () {},
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
