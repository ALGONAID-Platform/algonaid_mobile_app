import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/heroWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/course_grades_provider.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/course_grades_widget.dart';
import 'package:provider/provider.dart';

class BuildExpertBadge extends StatefulWidget {
  final int courseId;
  const BuildExpertBadge({super.key, required this.courseId});

  @override
  State<BuildExpertBadge> createState() => _BuildExpertBadgeState();
}

class _BuildExpertBadgeState extends State<BuildExpertBadge> {
  late CourseGradesProvider _gradesProvider;

  @override
  void initState() {
    super.initState();
    _gradesProvider = getIt<CourseGradesProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gradesProvider.fetchGrades(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gradesProvider,
      child: Consumer<CourseGradesProvider>(
        builder: (context, provider, child) {
          final state = provider.getState(widget.courseId);
          final isUnlocked = (state.grades?.averagePercentage ?? 0.0) > 90;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) => Badge3DDialog(
            heroTag: "expert_badge_",
            title: "وسام التفوق الذهبي",
            description: isUnlocked
                ? "عمل رائع وإنجاز استثنائي! لقد اجتزت جميع التحديات بجدارة واستحقاق، وحصلت على وسام التفوق الذهبي. أنت بالفعل بطل هذه المادة!"
                : "كن بطل هذه المادة! ستتوج بـ وسام التفوق الذهبي عند إتمامك لجميع وحدات الكورس بنجاح واجتياز كافة الاختبارات بمعدل لا يقل عن %90. استمر، العظمة بانتظارك!",
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
          border: AppBorder.main_border
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
                          color: isUnlocked 
                              ? Colors.green.withOpacity(0.15) 
                              : context.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isUnlocked ? "مكتمل" : "قيد السعي",
                          style: context.textTheme.labelMedium!.copyWith(
                            color: isUnlocked ? Colors.green : context.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              AppBottomSheet.show(
                                context: context,
                                title: "تفاصيل درجات اختبارات الكورس",
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                                child: CourseGradesWidget(courseId: widget.courseId),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "عرض تفاصيل الدرجات",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                      child: kIsWeb
                          ? Image.asset(
                              Images.trophy,
                              width: 130,
                              height: 130,
                              fit: BoxFit.contain,
                            )
                          : Lottie.asset(
                              AppLottie.goldMedal,
                              width: 130,
                              height: 130,
                              fit: BoxFit.contain,
                            ),
                    ),

                    if (!isUnlocked)
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
        },
      ),
    );
  }
}
