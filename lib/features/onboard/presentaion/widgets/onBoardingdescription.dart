
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/onboard/domain/entity/onboarding_entity.dart';
import 'package:flutter/material.dart';

class OnBoardingDescription extends StatelessWidget {
  const OnBoardingDescription({
    super.key,
    required this.isCurrentPage,
    required this.item,
  });

  final bool isCurrentPage;
  final OnboardingEntity item;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isCurrentPage ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          item.description,
          textDirection: TextDirection.rtl,
          style: Styles.textStyle16,
        ),
      ),
    );
  }
}
