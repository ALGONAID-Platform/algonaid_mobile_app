import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/animation.dart';
import 'package:algonaid_mobile_app/features/onboard/data/models/onboarding_data.dart';
import 'package:algonaid_mobile_app/features/onboard/domain/entity/onboarding_entity.dart';
import 'package:algonaid_mobile_app/features/onboard/presentation/providers/onboarding_provider.dart';
import 'package:algonaid_mobile_app/features/onboard/presentation/widgets/onBoardingFooter.dart';
import 'package:algonaid_mobile_app/features/onboard/presentation/widgets/onBoardingImage.dart';
import 'package:algonaid_mobile_app/features/onboard/presentation/widgets/onBoardingTitle.dart';
import 'package:algonaid_mobile_app/features/onboard/presentation/widgets/onBoardingdescription.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingEntity> items = OnboardingData.items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, onboardinValue, child) {
            double targetProgress =
                (onboardinValue.current_bage + 1) / items.length;

            return Stack(
              children: [
                MathBackground(),

                PageView.builder(
                  onPageChanged: (value) => onboardinValue.onPagechange(value),
                  controller: onboardinValue.pageController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    bool isCurrentPage = onboardinValue.current_bage == index;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                OnboardingImage(
                                  isCurrentPage: isCurrentPage,
                                  item: items[index],
                                ),
                                const SizedBox(height: 30),
                                OnBoardingTitle(
                                  isCurrentPage: isCurrentPage,
                                  item: items[index],
                                ),
                                const SizedBox(height: 20),
                                OnBoardingDescription(
                                  isCurrentPage: isCurrentPage,
                                  item: items[index],
                                ),
                              ],
                            ),
                          ),
                        ),
                        OnBoardingFooterAnimated(
                          targetProgress: targetProgress,
                          onboardinValue: onboardinValue,
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
