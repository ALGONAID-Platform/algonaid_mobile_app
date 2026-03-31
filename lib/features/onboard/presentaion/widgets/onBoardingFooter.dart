import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/providers/onboarding_provider.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/widgets/moveButtonWidget.dart';
import 'package:flutter/material.dart';

class OnBoardingFooterAnimated extends StatelessWidget {
  const OnBoardingFooterAnimated({
    super.key,
    required this.targetProgress,
    required this.onboardinValue,
  });

  final double targetProgress;
  final OnboardingProvider onboardinValue;

  @override
  Widget build(BuildContext context) {
    bool isFirstPage = onboardinValue.current_bage == 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: isFirstPage
              ? Row(
                  key: const ValueKey<int>(0), // Key for the first page layout
                  children: [
                    MoveButtonWidget(
                      targetProgress: targetProgress,
                      onboardinValue: onboardinValue,
                    ),
                    const Spacer(),
                    Text("ابدأ من هنا!", style: Styles.textStyle24),
                  ],
                )
              : Row(
                  key: const ValueKey<int>(
                    1,
                  ), // Key for subsequent pages layout
                  children: [
                    BackButton(
                      onPressed: () {
                        onboardinValue.goToPrevousPage();
                      },
                    ),
                    const Spacer(),
                    MoveButtonWidget(
                      targetProgress: targetProgress,
                      onboardinValue: onboardinValue,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
