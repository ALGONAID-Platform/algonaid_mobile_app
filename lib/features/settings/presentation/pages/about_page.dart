import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/features/settings/data/datasources/settings_static_datasource.dart';
import 'package:algonaid_mobile_app/features/settings/domain/entities/platform_feature.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    const dataSource = SettingsStaticDataSourceImpl();
    final features = dataSource.getPlatformFeatures();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: const SharedAppBar(
          title: 'حول المنصة',
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // بطاقة التعريف العلوية
              _buildHeaderSection(context, isDark),
              const SizedBox(height: 24),
              // الأقسام التفصيلية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      context,
                      title: 'من نحن',
                      description:
                          'منصة الجنيد التعليمية هي منصة رقمية رائدة ومتخصصة في تقديم شروحات مادة الرياضيات بأساليب حديثة ومبتكرة. نسعى لتمكين الطلاب في مختلف المراحل الدراسية من استيعاب المفاهيم الرياضية المعقدة وتجاوز الصعوبات الأكاديمية بكل سهولة ويسر.',
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context,
                      title: 'رؤيتنا ورسالتنا',
                      description:
                          'نهدف إلى تغيير الطريقة التقليدية في تعلم الرياضيات، وتحويلها من مادة صعبة الحفظ إلى تجربة تفاعلية ممتعة تعتمد على الفهم والتحليل البصري والتطبيق المستمر، لخلق جيل متميز ومتمكن رياضياً وعلمياً.',
                      icon: Icons.lightbulb_outline_rounded,
                      iconColor: AppColors.amber,
                    ),
                    const SizedBox(height: 16),
                    _buildFeaturesSection(context, features),
                    const SizedBox(height: 32),
                    // رقم النسخة والحقوق
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'منصة الجنيد التعليمية',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onBackground
                                  .withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onBackground
                                  .withOpacity(0.4),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.indigo, AppColors.indigoDark]
              : [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // أشكال هندسية خلفية لإيحاء الرياضيات
          Positioned(
            left: -20,
            bottom: -20,
            child: Icon(
              Icons.calculate_outlined,
              size: 150,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.functions_rounded,
              size: 120,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 24.0,
            ),
            child: Column(
              children: [
                // لوجو دائري مبسط
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'منصة الجنيد التعليمية',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'شريكك نحو التفوق والتميز في مادة الرياضيات',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: AppBorder.main_border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onBackground.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(
    BuildContext context,
    List<PlatformFeature> features,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ماذا تقدم لك المنصة؟',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature.title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onBackground.withOpacity(
                          0.85,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
