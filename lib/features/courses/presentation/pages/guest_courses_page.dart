import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/guest_login_dialog.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/timeout_image_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/bottomNavigationBar.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/pages/competitions_page.dart';
import 'package:algonaid_mobile_app/features/downloads/presentation/pages/downloads_page.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/custom_threshold_refresh_indicator.dart';

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
          return Stack(
            children: [
              CustomThresholdRefreshIndicator(
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
                                  'يمكنك تسجيل الدخول لفتح تفاصيل الكورس والتسجيل فيه، أو المتابعة في تصفح الكورسات كضيف.',
                              onLogin: () {
                                context.read<AuthServiceProvider>().setAuthMode(true);
                                context.push(Routes.auth);
                              },
                            );
                          },
                        ),
                ),
              ),
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: SyncStatusIndicator(
                  isUpdating: provider.isBackgroundUpdating,
                  errorMessage: provider.errorMessage,
                ),
              ),
            ],
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

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: courses.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _GuestWelcomeCard(),
          );
        }

        final course = courses[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AspectRatio(
            aspectRatio: 1.32,
            child: _GuestCourseCard(
              course: course,
              onTap: () => onCourseTap(course),
            ),
          ),
        );
      },
    );
  }
}

class _GuestWelcomeCard extends StatelessWidget {
  const _GuestWelcomeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.indigoDark.withOpacity(0.85), AppColors.indigo]
              : [context.primary.withOpacity(0.9), context.primary.withOpacity(0.7)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.primary.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -24,
            top: -24,
            child: Icon(
              Icons.school_outlined,
              size: 140,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'أهلاً بك في منصة الجنيد!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'أنشئ حسابك الآن مجاناً لتسجيل حضورك وحفظ تقدمك الدراسي، بالإضافة إلى خوض المسابقات والتحديات المميزة مع زملائك.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthServiceProvider>().setAuthMode(false);
                        context.push(Routes.auth);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: context.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ابدأ الآن مجاناً',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        context.read<AuthServiceProvider>().setAuthMode(true);
                        context.push(Routes.auth);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'لدي حساب بالفعل',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestCourseCard extends StatelessWidget {
  final dynamic course;
  final VoidCallback onTap;

  const _GuestCourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasNoImage = Images.isInvalidImage(course.thumbnail as String?);
    String resolvedUrl = course.thumbnail as String? ?? '';
    if (!hasNoImage && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }
    final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
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
                    (hasNoImage || isResolvedInvalid)
                        ? Image.asset(
                            Images.noImageFound,
                            fit: BoxFit.cover,
                          )
                        : TimeoutImageWrapper(
                            imageUrl: resolvedUrl,
                            fit: BoxFit.cover,
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
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        course.title as String? ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المدرب: ${course.teacher.user.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        course.description as String? ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant.withOpacity(0.8),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عدد الوحدات: ${course.modulesCount}',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.arrow_back_ios_new,
                            size: 14,
                            color: context.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _GuestGridShimmer extends StatelessWidget {
  const _GuestGridShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 160,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceVariant.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AspectRatio(
            aspectRatio: 1.32,
            child: Container(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 12,
                            width: 120,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceVariant.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 14,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surfaceVariant.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surfaceVariant.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
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
        titleSpacing: 16,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getAppBarTitle(_currentIndex),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  context.read<AuthServiceProvider>().setAuthMode(true);
                  context.push(Routes.auth);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: context.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
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
