import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/features/settings/data/datasources/settings_static_datasource.dart';
import 'package:algonaid_mobile_app/features/settings/domain/entities/developer_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';

class DevelopersPage extends StatefulWidget {
  const DevelopersPage({Key? key}) : super(key: key);

  @override
  State<DevelopersPage> createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;

  final List<DeveloperInfo> _developers = const SettingsStaticDataSourceImpl()
      .getDevelopers();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: const SharedAppBar(
          title: 'طاقم التطوير',
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildTeamHeaderCard(context, isDark),
                const SizedBox(height: 28),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _developers.length,
                  itemBuilder: (context, index) {
                    final dev = _developers[index];

                    final delay = index * 0.15;
                    final start = delay;
                    final end = (delay + 0.4).clamp(0.0, 1.0);

                    final cardAnimation = CurvedAnimation(
                      parent: _fadeController,
                      curve: Interval(start, end, curve: Curves.easeOutBack),
                    );

                    return AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1.0 - cardAnimation.value)),
                          child: Opacity(
                            opacity: cardAnimation.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: _buildDeveloperCard(context, dev),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamHeaderCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.indigoDark, AppColors.indigo]
              : [AppColors.primary.withOpacity(0.9), AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: -20,
            child: Icon(
              Icons.group_work_outlined,
              size: 130,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 20.0,
            ),
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
                        Icons.developer_mode_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'فريق كوديان (Codyan)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'نحن مجموعة من المطورين والمصممين الشغوفين ببناء حلول تعليمية مبتكرة وسهلة الاستخدام، قمنا بتطوير وبرمجة منصة الجنيد لتقديم أفضل تجربة دراسية للطلاب.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, DeveloperInfo dev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: AppBorder.main_border,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              dev.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [dev.themeColor, dev.themeColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(dev.avatarIcon, color: Colors.white, size: 28),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              dev.name,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                context,
                icon: Icons.code_rounded,
                tooltip: 'GitHub',
                color: context.isDarkMode
                    ? Colors.white.withOpacity(0.9)
                    : AppColors.indigo,
                onPressed: () => _launchURL(dev.githubUrl),
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                context,
                icon: Icons.link_rounded,
                tooltip: 'LinkedIn',
                color: const Color(0xFF0A66C2), // LinkedIn blue
                onPressed: () => _launchURL(dev.linkedinUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
