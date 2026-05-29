import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/badges_section.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/presentation/widgets/excellence_courses_section.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ProfileHeader(),
              const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
              const ExcellenceCoursesSection(),
              const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
              BadgesSection(),
              const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
              const SettingsSection(),
              const SizedBox(height: 100), // Padding for BottomNavigationBar
            ],
          ),
        ),
      ),
    );
  }
}
