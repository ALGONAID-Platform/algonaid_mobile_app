
import 'package:algonaid_mobail_app/features/onboard/domain/entity/onboarding_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({
    super.key,
    required this.isCurrentPage,
    required this.item,
  });

  final bool isCurrentPage;
  final OnboardingEntity item;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(top: isCurrentPage ? 20 : 60),
      padding: const EdgeInsets.all(8.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isCurrentPage ? 1.0 : 0.0,
        child: SvgPicture.asset(
          item.image_url,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      ),
    );
  }
}
