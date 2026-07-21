import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:flutter/services.dart';
import 'package:algonaid/core/constants/app_constants.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:algonaid/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid/core/widgets/shared/section_header.dart';
import 'package:algonaid/features/courses/presentation/widgets/all_courses_section.dart';
import 'package:algonaid/features/courses/presentation/widgets/bottomNavigationBar.dart';
import 'package:algonaid/features/courses/presentation/widgets/buildShimmerSection.dart';
import 'package:algonaid/features/courses/presentation/widgets/courseHeader.dart';
import 'package:algonaid/features/courses/presentation/widgets/my_courses_section.dart';
import 'package:algonaid/features/courses/presentation/widgets/sliver_appbar.dart';
import 'package:algonaid/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid/features/profile/presentation/pages/profile_page.dart';
import 'package:algonaid/features/downloads/presentation/pages/downloads_page.dart';
import 'package:algonaid/features/courses/presentation/pages/competitions_page.dart';
import 'package:algonaid/core/widgets/shared/show_dialog.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;
import 'package:algonaid/core/widgets/shared/custom_threshold_refresh_indicator.dart';


class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _isBackgroundRefreshing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetCoursesProvider>().refreshAll(isGuest: false);
      // تأجيل طلب الوحدة الأخيرة حتى لا تنطلق طلبا شبكيين في نفس اللحظة
      // Future.microtask تؤجلل حتى بعد اكتمال دورة الأحداث الحالية
      Future.microtask(() {
        if (mounted) {
          context.read<LastAccessedModuleProvider>().fetchLastAccessedModule();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Stack(
        children: [
          // Premium Subtle Geometric Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: MainBackgroundPainter(
                isDark: context.isDarkMode,
                primaryColor: context.primary,
              ),
            ),
          ),
          CustomThresholdRefreshIndicator(
            elevation: 0.0,
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            strokeWidth: 0, // Make it invisible
            notificationPredicate: (ScrollNotification notification) {
              return defaultScrollNotificationPredicate(notification) && notification.metrics.pixels <= 0;
            },
            onRefresh: () async {
              setState(() => _isBackgroundRefreshing = true);
              final coursesProvider = context.read<GetCoursesProvider>();
              final lastAccessedProvider = context
                  .read<LastAccessedModuleProvider>();

              await Future.wait([
                coursesProvider.refreshAll(isGuest: false),
                lastAccessedProvider.fetchLastAccessedModule(forceRefresh: true),
              ]);
              if (mounted) setState(() => _isBackgroundRefreshing = false);
            },
            child: Consumer<GetCoursesProvider>(
              builder: (context, provider, child) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: SectionHeader(text: 'اخر وحده دخلتها')),
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
                            courseHeader(
                              hasEnrolledCourses: provider.myCourses.isNotEmpty,
                            ),
                            MyCoursesListSection(
                              myCourses: provider.myCourses,
                              allCourses: provider.allCourses,
                            ),
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
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Consumer<GetCoursesProvider>(
              builder: (context, provider, child) {
                return SyncStatusIndicator(
                  isUpdating: _isBackgroundRefreshing || provider.isBackgroundUpdating,
                  errorMessage: provider.errorMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesHomePage extends StatefulWidget {
  const CoursesHomePage({super.key});

  @override
  State<CoursesHomePage> createState() => _CoursesHomePageState();
}

class _CoursesHomePageState extends State<CoursesHomePage> {
  final GlobalKey<ProfilePageState> _profileKey = GlobalKey<ProfilePageState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CoursesPage(key: ValueKey('home')),
      const CompetitionsPage(key: ValueKey('competitions')),
      const DownloadsPage(key: ValueKey('bookmarks')),
      ProfilePage(key: _profileKey),
    ];
  }

  void _navigateToProfile() {
    if (_currentIndex == 3) {
      // إذا كنا على تاب البروفايل وضغطنا مرة ثانية، نحدث البيانات
      _profileKey.currentState?.refreshData(forceRefresh: true);
    }
    setState(() => _currentIndex = 3);
  }

  String? _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return 'المسابقات والتحديات';
      case 2:
        return ' الدروس المحفوظة';
      case 3:
        return 'الملف الشخصي';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // لا يوجد هنا أي context.watch — بيانات المستخدم تُقرأ داخل ReactiveAppBar
    // عبر context.select حتى لا تُعيد بناء هذه الصفحة كاملةً عند كل تغيير
    return PopScope(
      // نمنع الخروج الافتراضي دائماً لنتعامل معه يدوياً
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          // إذا كنا في أي تاب غير الرئيسي، نرجع للصفحة الرئيسية
          setState(() => _currentIndex = 0);
        } else {
          // إذا كنا في الصفحة الرئيسية، نسأل المستخدم هل يريد الخروج
          AppDialog.showDynamicDialog(
            context: context,
            title: 'الخروج من التطبيق',
            message: 'هل تريد الخروج من التطبيق؟',
            isError: true, // اللون الأحمر مناسب للخروج
            confirmText: 'خروج',
            cancelText: 'إلغاء',
            onConfirm: () {
              SystemNavigator.pop();
            },
          );
        }
      },
      child: Scaffold(
      backgroundColor: context.background,
      appBar: ReactiveAppBar(
        appBarTitle: _getAppBarTitle(_currentIndex),
        isGuest: false,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onProfilePressed: _navigateToProfile,
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
                if (index == 3) {
                  _navigateToProfile();
                } else {
                  setState(() => _currentIndex = index);
                }
              },
            ),
          ),
        ],
      ),
      ),  // end Scaffold
    );  // end PopScope
  }
}

class ReactiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarTitle;
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onMenuPressed;
  final bool isGuest;

  const ReactiveAppBar({
    super.key,
    this.appBarTitle,
    required this.onProfilePressed,
    required this.onNotificationPressed,
    required this.onSearchPressed,
    required this.onMenuPressed,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام context.select بدلاً من context.watch حتى نعيد بناء الـ AppBar
    // فقط عند تغيير القيمة المحددة (الاسم والصورة)، لا عند أي تغيير في الـ provider
    final profileName = context.select<ProfileProvider, String?>(
      (p) => p.userProfile?.name,
    );
    final profileAvatar = context.select<ProfileProvider, String?>(
      (p) => p.userProfile?.avatar,
    );
    final localAvatarPath = context.select<ProfileProvider, String?>(
      (p) => p.localAvatarPath,
    );
    final authName = context.select<AuthServiceProvider, String?>(
      (p) => p.user?.username,
    );
    final authAvatar = context.select<AuthServiceProvider, String?>(
      (p) => p.user?.avatar,
    );

    final userName = (profileName != null && profileName.isNotEmpty)
        ? profileName
        : ((authName != null && authName.isNotEmpty)
            ? authName
            : (CacheHelper.getString(key: AppConstants.userName) ?? 'مستخدم'));

    String? userAvatar = (profileAvatar != null && profileAvatar.isNotEmpty)
        ? profileAvatar
        : null;
    userAvatar ??= (authAvatar != null && authAvatar.isNotEmpty)
        ? authAvatar
        : null;
    userAvatar ??= CacheHelper.getString(key: AppConstants.userAvatar);

    return ValueListenableBuilder<Box<String>>(
      valueListenable: Hive.box<String>('local_notifications_box').listenable(),
      builder: (context, box, _) {
        final currentUserId = CacheHelper.getString(key: AppConstants.userId) ?? '0';
        final unreadCount = box.values
            .map((e) {
              try {
                return jsonDecode(e) as Map<String, dynamic>;
              } catch (_) {
                return <String, dynamic>{};
              }
            })
            .where((map) {
              final isRead = map['isRead'] as bool? ?? false;
              final notifUserId = map['userId'] as String?;
              return !isRead && (notifUserId == currentUserId || notifUserId == null);
            })
            .length;

        return CustomWhiteAppBar(
          userName: userName,
          userImageUrl: userAvatar,
          localAvatarPath: localAvatarPath,
          appBarTitle: appBarTitle,
          notificationCount: unreadCount,
          onMenuPressed: onMenuPressed,
          onProfilePressed: onProfilePressed,
          onNotificationPressed: onNotificationPressed,
          onSearchPressed: onSearchPressed,
          isGuest: isGuest,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}

// Custom painter to draw premium, lightweight geometric hexagons and dot grids in the background
class MainBackgroundPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;

  MainBackgroundPainter({required this.isDark, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(isDark ? 0.06 : 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // 1. Draw subtle concentric hexagons in the top-right corner
    _drawHexagon(canvas, Offset(size.width * 0.9, size.height * 0.15), 60.0, paint);
    _drawHexagon(canvas, Offset(size.width * 0.9, size.height * 0.15), 40.0, paint);

    // 2. Draw subtle concentric hexagons in the middle-left area
    _drawHexagon(canvas, Offset(size.width * 0.1, size.height * 0.45), 80.0, paint);
    _drawHexagon(canvas, Offset(size.width * 0.1, size.height * 0.45), 50.0, paint);

    // 3. Draw subtle concentric hexagons in the bottom-right area
    _drawHexagon(canvas, Offset(size.width * 0.85, size.height * 0.75), 100.0, paint);
    _drawHexagon(canvas, Offset(size.width * 0.85, size.height * 0.75), 70.0, paint);

    // 4. Draw a faint dot grid in the top-left area
    final dotPaint = Paint()
      ..color = primaryColor.withOpacity(isDark ? 0.08 : 0.12)
      ..style = PaintingStyle.fill;
    
    final startX = size.width * 0.05;
    final startY = size.height * 0.1;
    final spacing = 16.0;
    final rows = 8;
    final cols = 8;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(startX + c * spacing, startY + r * spacing),
          1.2,
          dotPaint,
        );
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60) * (math.pi / 180.0);
      double x = center.dx + radius * math.cos(angle);
      double y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

