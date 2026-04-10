import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class WelcomeNewUserCard extends StatelessWidget {
  const WelcomeNewUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الثيم الحالي
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // نحافظ على التدرج النيلي كـ Brand Identity ثابتة
          gradient: AppColors.indigoGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.indigo.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            const _BackgroundDecorations(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _WelcomeIcon(),
                  const SizedBox(height: 16),
                  const _WelcomeText(),
                  const SizedBox(height: 24),
                  // تمرير الثيم للزر ليتناسق
                  const _ActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// كلاس الزر المخصص
class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () {
        // التنقل لصفحة الاستكشاف
      },
      style: ElevatedButton.styleFrom(
        // الاعتماد على ألوان الثيم الأساسية
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        'استكشف الكورسات الآن',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _WelcomeIcon extends StatelessWidget {
  const _WelcomeIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // اللون الكهرماني من الثيم (أو ثابت للتميز)
        color: AppColors.amber.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.amber,
        size: 32,
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مرحباً بك في أكاديمية الجنيد! 🚀',
          style: TextStyle(
            color: Colors.white, // أبيض دائماً لأن الخلفية نيلي داكن
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'رحلتك نحو التميز تبدأ من هنا. آلاف الدروس التعليمية صممت خصيصاً لتناسب مستواك وتطور مهاراتك.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _BackgroundDecorations extends StatelessWidget {
  const _BackgroundDecorations();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -20,
      right: -20,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}
