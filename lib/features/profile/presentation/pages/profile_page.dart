import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/widgets/badges_section.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/presentation/widgets/excellence_courses_section.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/custom_threshold_refresh_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                await Future.wait([
                  context.read<GetCoursesProvider>().refreshAll(isGuest: false),
                  context.read<ProfileProvider>().loadTotalPoints(),
                  context.read<ProfileProvider>().loadUserProfile(),
                  context.read<ProfileProvider>().loadUserBadges(forceRefresh: true),
                ]);
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
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
