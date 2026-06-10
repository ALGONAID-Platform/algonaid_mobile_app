import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/guest_login_dialog.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/bottomNavigationBar.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/pages/competitions_page.dart';
import 'package:algonaid_mobile_app/features/downloads/presentation/pages/downloads_page.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';

class GuestCoursesPage extends StatefulWidget {
  const GuestCoursesPage({super.key});

  @override
  State<GuestCoursesPage> createState() => _GuestCoursesPageState();
}

class _GuestCoursesPageState extends State<GuestCoursesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCoursesProvider>().refreshAll(isGuest: true);
    });
  }

  Future<void> _refreshCourses() async {
    final provider = context.read<GetCoursesProvider>();
    await provider.refreshAll(isGuest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Consumer<GetCoursesProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refreshCourses,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: provider.isLoading
                  ? const _GuestGridShimmer()
                  : _GuestCoursesGrid(
                      courses: provider.allCourses,
                      onCourseTap: (course) {
                        showGuestLoginDialog(
                          context,
                          title: 'هذا الكورس يحتاج تسجيل دخول',
                          message:
                              'يمكنك تسجيل الدخول لفتح تفاصيل الكورس والتسجيل فيه، أو المتابعة في تصفح الكورسات.',
                          onLogin: () => context.push(Routes.auth),
                          onGuest: () {},
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _GuestCoursesGrid extends StatelessWidget {
  final List<dynamic> courses;
  final ValueChanged<dynamic> onCourseTap;

  const _GuestCoursesGrid({required this.courses, required this.onCourseTap});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 80),
          Icon(Icons.menu_book_rounded, size: 56, color: context.primary),
          const SizedBox(height: 16),
          Text(
            'لا توجد كورسات متاحة حالياً',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حاول التحديث لاحقاً.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _GuestCourseCard(
          course: course,
          onTap: () => onCourseTap(course),
        );
      },
    );
  }
}

class _GuestCourseCard extends StatelessWidget {
  final dynamic course;
  final VoidCallback onTap;

  const _GuestCourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String resolvedUrl = course.thumbnail as String? ?? '';
    if (resolvedUrl.isNotEmpty && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(18),
          border: AppBorder.main_border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: resolvedUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: context.colorScheme.surfaceVariant.withOpacity(
                          0.45,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: context.colorScheme.surfaceVariant.withOpacity(
                          0.45,
                        ),
                        child: Image.asset(
                          Images.noImageFound,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Text(
                        course.title as String? ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.teacher.user.name as String? ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوحدات: ${course.modulesCount}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: context.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestGridShimmer extends StatelessWidget {
  const _GuestGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(18),
            border: AppBorder.main_border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceVariant.withOpacity(0.35),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceVariant.withOpacity(
                            0.5,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 90,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceVariant.withOpacity(
                            0.35,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GuestCoursesPage(key: ValueKey('guest_home')),
    const CompetitionsPage(key: ValueKey('guest_competitions')),
    const DownloadsPage(key: ValueKey('guest_bookmarks')),
  ];

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'منصة الجنيد التعليمية';
      case 1:
        return 'المسابقات والتحديات';
      case 2:
        return 'الدروس المحفوظة';
      default:
        return 'منصة الجنيد التعليمية';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;

                if (screenWidth > 380) {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<AuthServiceProvider>().setAuthMode(true);
                          context.push(Routes.auth);
                        },
                        child: const Text('تسجيل الدخول'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthServiceProvider>().setAuthMode(
                            false,
                          );
                          context.push(Routes.auth);
                        },
                        child: const Text('إنشاء حساب'),
                      ),
                    ],
                  );
                }

                return ElevatedButton(
                  onPressed: () {
                    context.read<AuthServiceProvider>().setAuthMode(true);
                    context.push(Routes.auth);
                  },
                  child: const Text('تسجيل الدخول'),
                );
              },
            ),

            Text(
              _getAppBarTitle(_currentIndex),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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
              isGuest: true,
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
