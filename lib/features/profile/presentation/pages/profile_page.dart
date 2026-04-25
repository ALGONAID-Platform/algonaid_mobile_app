import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/badges_section.dart';
<<<<<<< HEAD
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/profile_header.dart'; // Added
=======
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/profile_header.dart';
>>>>>>> origin/feat/darktheme
import 'package:algonaid_mobail_app/features/profile/presentation/widgets/settings_section.dart';
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
            children: const [
              ProfileHeader(),
<<<<<<< HEAD
              Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
              BadgesSection(),
              Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey),
=======
              Divider(height: 1, indent: 16, endIndent: 16),
              BadgesSection(),
              Divider(height: 1, indent: 16, endIndent: 16),
>>>>>>> origin/feat/darktheme
              SettingsSection(),
              SizedBox(height: 100), // Padding for BottomNavigationBar
            ],
          ),
        ),
      ),
    );
  }
}
