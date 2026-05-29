import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';

class CompetitionsPage extends StatelessWidget {
  const CompetitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: const AppEmptyState(
        icon: Icons.emoji_events_rounded,
        title: 'قريباً..',
        subtitle: 'استعد لتحدي نفسك والمنافسة مع أصدقائك!',
      ),
    );
  }
}
