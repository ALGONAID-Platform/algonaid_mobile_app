import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/heroWidget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuildExpertBadge extends StatelessWidget {
  const BuildExpertBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => Badge3DDialog(
            heroTag: "expert_badge_",
            title: "وسام التفوق الذهبي",
            description:
                "كن بطل هذه المادة! ستتوج بـ وسام التفوق الذهبي عند إتمامك لجميع وحدات الكورس بنجاح واجتياز كافة الاختبارات بمعدل لا يقل عن %90. استمر، العظمة بانتظارك!",
            lottie: AppLottie.goldMedal,
            gradientColors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 233, 230, 200),
            ],
            borderColor: AppColors.amber,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.only(right: 16, top: 24, bottom: 24),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? context.onSecondary.withOpacity(0.05)
              : context.primary.withOpacity(0.05),

          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: context.isDarkMode
                ? AppColors.indigoDark
                : context.primary.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "وسام التفوق الذهبي",
                        style: context.theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "أكمل 100% من الوحدة بمتوسط 90%",
                        style: context.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "قيد السعي",
                          style: context.textTheme.labelMedium!.copyWith(
                            color: context.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),
                Stack(
                  alignment: Alignment.center, // لضمان تمركز القفل فوق الوسام
                  children: [
                    AppHero(
                      tag: "MedalHero",
                      child: Lottie.asset(
                        AppLottie.goldMedal,
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: Color.fromARGB(161, 255, 255, 255),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
