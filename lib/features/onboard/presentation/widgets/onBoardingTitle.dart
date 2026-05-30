import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/onboard/domain/entity/onboarding_entity.dart';
import 'package:flutter/material.dart';

class OnBoardingTitle extends StatelessWidget {
  const OnBoardingTitle({
    super.key,
    required this.isCurrentPage,
    required this.item,
  });

  final bool isCurrentPage;
  final OnboardingEntity item;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 600),
      padding: EdgeInsets.only(right: isCurrentPage ? 20 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 2,
            right: 0,
            left: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              height: 10,
              // الخط العريض يظهر عرضه تدريجياً
              width: isCurrentPage ? 100 : 0,
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          Text(item.title, style: Styles.textStyle24),
        ],
      ),
    );
  }
}
