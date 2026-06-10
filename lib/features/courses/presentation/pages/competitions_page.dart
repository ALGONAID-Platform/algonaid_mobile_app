import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid_mobile_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompetitionsPage extends StatelessWidget {
  const CompetitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final token = TokenStorage.getToken();
    final isGuest = token == null || token.trim().isEmpty;

    final bodyContent = const AppEmptyState(
      icon: Icons.emoji_events_rounded,
      title: 'قريباً..',
      subtitle: 'استعد لتحدي نفسك والمنافسة مع أصدقائك!',
    );

    return Scaffold(
      backgroundColor: context.background,
      body: isGuest
          ? Column(
              children: [
                _buildGuestBanner(context),
                Expanded(child: bodyContent),
              ],
            )
          : bodyContent,
    );
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: context.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'سجل دخولك لتتمكن من المشاركة في المسابقات والتحديات مع زملائك.',
              textDirection: TextDirection.rtl,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => context.push(Routes.auth),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('سجل الآن'),
          ),
        ],
      ),
    );
  }
}
