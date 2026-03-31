import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';

class MoveButtonWidget extends StatelessWidget {
  const MoveButtonWidget({
    super.key,
    required this.targetProgress,
    required this.onboardinValue,
  });
  final OnboardingProvider onboardinValue;

  final double targetProgress;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500), // سرعة حركة الإطار
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: targetProgress),
        builder: (context, animatedValue, child) {
          return GestureDetector(
            onTap: () {
              onboardinValue.goToNextPage();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // الإطار المتحرك
                SizedBox(
                  width: 75,
                  height: 75,
                  child: CircularProgressIndicator(
                    value:
                        animatedValue, // القيمة المتحركة القادمة من الـ Tween
                    strokeWidth: 4,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                // الزر الثابت في المنتصف
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
