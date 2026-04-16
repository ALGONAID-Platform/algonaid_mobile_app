import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/features/onboard/data/models/onboarding_data.dart';
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
    bool isLastPage =
        onboardinValue.current_bage == OnboardingData.items.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            // AnimatedSwitcher للتبديل بين نص 'ابدأ من هنا!' وزر الرجوع
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // استخدام FadeTransition و SizeTransition معًا لتحقيق تأثير الدمج
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal, // لتمدد أفقي
                    child: child,
                  ),
                );
              },
              child: isFirstPage
                  ? Text(
                      "ابدأ من هنا!",
                      key: const ValueKey('startText'), // مفتاح فريد للنص
                      style: Styles.textStyle24,
                    )
                  : BackButton(
                      key: const ValueKey(
                        'backButton',
                      ), // مفتاح فريد لزر الرجوع
                      onPressed: () {
                        onboardinValue.goToPrevousPage();
                      },
                    ),
            ),
            const Spacer(),
            MoveButtonWidgetAnimated(
              isLastPage: isLastPage,
              targetProgress: targetProgress,
              onboardinValue: onboardinValue,
            ),
          ],
        ),
      ),
    );
  }
}
