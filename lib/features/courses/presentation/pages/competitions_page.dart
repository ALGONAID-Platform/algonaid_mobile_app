import 'dart:ui';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CompetitionsPage extends StatelessWidget {
  const CompetitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final token = TokenStorage.getToken();
    final isGuest = token == null || token.trim().isEmpty;

    return Scaffold(
      backgroundColor: context.background,
      body: Stack(
        children: [
          // Background preview of competitions page
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMockLeaderboard(context),
                  const SizedBox(height: 24),
                  _buildMockChallenges(context),
                ],
              ),
            ),
          ),
          // Overlay based on whether it is a guest or logged-in user
          Positioned.fill(
            child: isGuest ? _buildLockOverlay(context) : _buildComingSoonOverlay(context),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonOverlay(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      color: (isDark ? Colors.black : Colors.white).withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hourglass Icon Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'المسابقات قادمة قريباً!',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'نعمل حالياً على تطوير وبرمجة نظام المسابقات والتحديات لتتمكن من منافسة زملائك واكتساب النقاط والأوسمة. ترقبوها قريباً في التحديث القادم!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockLeaderboard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: AppBorder.main_border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'لوحة المتصدرين الأسبوعية',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Podium (منصة التتويج)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd Place (Silver)
              _buildPodiumItem(
                context,
                name: 'سارة خالد',
                score: '1850 ن',
                place: 2,
                height: 90,
                color: Colors.grey.shade400,
              ),
              // 1st Place (Gold)
              _buildPodiumItem(
                context,
                name: 'أحمد محمد',
                score: '2100 ن',
                place: 1,
                height: 120,
                color: const Color(0xFFFBBF24), // Gold Amber
              ),
              // 3rd Place (Bronze)
              _buildPodiumItem(
                context,
                name: 'عمر علي',
                score: '1720 ن',
                place: 3,
                height: 75,
                color: const Color(0xFFCD7F32), // Bronze
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List rows
          _buildMockLeaderboardRow(context, rank: 4, name: 'ريما أحمد', score: '1520 نقطة'),
          const SizedBox(height: 8),
          _buildMockLeaderboardRow(context, rank: 5, name: 'خالد سعيد', score: '1480 نقطة'),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    BuildContext context, {
    required String name,
    required String score,
    required int place,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          place == 1 ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded,
          color: color,
          size: place == 1 ? 32 : 24,
        ),
        const SizedBox(height: 4),
        Container(
          width: 65,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          alignment: Alignment.center,
          child: Text(
            '#$place',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          score,
          style: context.textTheme.bodySmall?.copyWith(color: context.primary),
        ),
      ],
    );
  }

  Widget _buildMockLeaderboardRow(
    BuildContext context, {
    required int rank,
    required String name,
    required String score,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '#$rank',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 12,
                backgroundColor: context.primary.withOpacity(0.2),
                child: Text(name[0], style: TextStyle(fontSize: 10, color: context.primary)),
              ),
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(score, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMockChallenges(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: AppBorder.main_border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'التحديات النشطة اليوم',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMockChallengeCard(
            context,
            title: 'تحدي الجبر السريع والمصفوفات',
            points: '+200 نقطة',
            duration: 'ينتهي خلال 4 ساعات',
          ),
          const SizedBox(height: 10),
          _buildMockChallengeCard(
            context,
            title: 'اختبار ذكاء المتتاليات الهندسية',
            points: '+150 نقطة',
            duration: 'ينتهي اليوم منتصف الليل',
          ),
        ],
      ),
    );
  }

  Widget _buildMockChallengeCard(
    BuildContext context, {
    required String title,
    required String points,
    required String duration,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flash_on_rounded, color: context.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  duration,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: TextStyle(color: context.primary, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLockOverlay(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      color: (isDark ? Colors.black : Colors.white).withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lock Icon Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'المسابقات قادمة قريباً!',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'نعمل حالياً على تطوير وبرمجة نظام المسابقات والتحديات لتتمكن من منافسة زملائك واكتساب النقاط والأوسمة. عند إطلاق الميزة، ستحتاج إلى حساب نشط للمشاركة، سجل حسابك الآن لتكون أول المستعدين!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

