import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:upgrader/upgrader.dart';
import 'package:algonaid/main.dart';
import 'package:algonaid/features/profile/presentation/widgets/badges_section.dart';
import 'package:algonaid/features/profile/presentation/widgets/custom_upgrade_card.dart';
import 'package:algonaid/features/excellence_courses/presentation/widgets/excellence_courses_section.dart';
import 'package:algonaid/features/profile/presentation/widgets/profile_header.dart';
import 'package:algonaid/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:algonaid/core/widgets/shared/custom_threshold_refresh_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

// public state class so CoursesHomePage can call refreshData via GlobalKey
class ProfilePageState extends State<ProfilePage> {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  Future<void> refreshData({bool forceRefresh = false}) async {
    if (!mounted) return;
    await Future.wait([
      context.read<GetCoursesProvider>().refreshAll(isGuest: false),
      context.read<ProfileProvider>().loadTotalPoints(),
      context.read<ProfileProvider>().loadUserProfile(),
      // forceRefresh دائماً عند الدخول الأول أو عند السحب للتحديث
      context.read<ProfileProvider>().loadUserBadges(
        forceRefresh: forceRefresh || !_hasLoadedOnce,
      ),
    ]);
    if (mounted) {
      setState(() => _hasLoadedOnce = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomThresholdRefreshIndicator(
              elevation: 0.0,
              color: Colors.transparent,
              backgroundColor: Colors.transparent,
              strokeWidth: 0,
              notificationPredicate: (ScrollNotification notification) {
                return defaultScrollNotificationPredicate(notification) && notification.metrics.pixels <= 0;
              },
              onRefresh: () async {
                await refreshData(forceRefresh: true);
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CustomUpgradeCard(
                            upgrader: sharedUpgrader,
                          ),
                        ),
                        const ProfileHeader(),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.grey,
                        ),
                        const ExcellenceCoursesSection(),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.grey,
                        ),
                        BadgesSection(),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.grey,
                        ),
                        const SettingsSection(),
                        const SizedBox(height: 100), // Padding for BottomNavigationBar
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Consumer2<GetCoursesProvider, ProfileProvider>(
                builder: (context, getCoursesProvider, profileProvider, child) {
                  return SyncStatusIndicator(
                    isUpdating: getCoursesProvider.isBackgroundUpdating || profileProvider.isBackgroundUpdating,
                    errorMessage: profileProvider.error ?? getCoursesProvider.errorMessage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
