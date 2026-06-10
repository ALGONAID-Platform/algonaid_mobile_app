import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/heroWidget.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/linearProgress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/module_grades_provider.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/widgets/module_grades_widget.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';

class ModuleHeaderStats extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final VoidCallback? onBack;
  const ModuleHeaderStats({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.onBack,
  });

  @override
  State<ModuleHeaderStats> createState() => _ModuleHeaderStatsState();
}

class _ModuleHeaderStatsState extends State<ModuleHeaderStats> {
  late ModuleGradesProvider _gradesProvider;

  @override
  void initState() {
    super.initState();
    _gradesProvider = getIt<ModuleGradesProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gradesProvider.fetchGrades(widget.moduleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gradesProvider,
      child: Consumer<ModuleGradesProvider>(
        builder: (context, provider, child) {
          final state = provider.getState(widget.moduleId);
          final isUnlocked = (state.grades?.averagePercentage ?? 0.0) > 85;

          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.moduleTitle,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "وحدة تعليمية",
                            style: context.textTheme.bodySmall?.copyWith(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: context.onBackground,
                            ),
                          ),
                          onPressed:
                              widget.onBack ??
                              () {
                                if (GoRouter.of(context).canPop()) {
                                  context.pop();
                                } else {
                                  context.go(
                                    '/homePage',
                                  ); // fallback to Routes.homePage
                                }
                              },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (context) => Badge3DDialog(
                          heroTag: "expert_badge_",
                          title: "وسام البراعة الفضي",
                          description: isUnlocked
                              ? "تهانينا! لقد أثبت براعتك واجتزت اختبارات هذه الوحدة بنجاح باهر، وحصلت على وسام البراعة الفضي بكل جدارة. استمر في هذا التميز!"
                              : "أنت على بُعد خطوة من التميّز! ستحصل على وسام البراعة الفضي عند اجتيازك لجميع اختبارات هذه الوحدة بنسبة %90 أو أكثر. أثبت مهاراتك الآن!",
                          lottie: AppLottie.goldMedal2,
                          gradientColors: [
                            const Color.fromARGB(255, 94, 94, 94),
                            const Color.fromARGB(255, 153, 153, 153),
                          ],
                          borderColor: AppColors.black,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: AppBorder.main_border,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primary.withOpacity(0.05)
                                  : const Color(0xFFF1FDF9),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment
                                      .center, // لضمان تمركز القفل فوق الوسام
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
                                              AppLottie.goldMedal2,
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
                                            color: Color.fromARGB(
                                              161,
                                              255,
                                              255,
                                              255,
                                            ),
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "وسام البراعة الفضي",
                                  style: theme.textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'يتطلب الحصول على درجة 85% أو أعلى في الاختبار النهائي.',
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          // الخط المنقط
                          const _DashedDivider(),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ملخص التقدم',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                    Text(
                                      '${(widget.progressPercentage).toInt()}%',
                                      style: context.textTheme.titleLarge!
                                          .copyWith(color: context.primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgress(
                                    progressPercentage:
                                        widget.progressPercentage,
                                    minHieght: 10,
                                    hPadding: 0,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'لقد أنجزت ${widget.completedLessons} دروس ومتبقي لك ${widget.totalLessons - widget.completedLessons} دروس لإنهاء هذه الوحدة.',
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                if (state.isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () {
                                      AppBottomSheet.show(
                                        context: context,
                                        title: 'تفاصيل درجات اختبارات الوحدة',
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 24,
                                        ),
                                        child: ModuleGradesWidget(
                                          moduleId: widget.moduleId,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text("عرض تفاصيل الدرجات"),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.maxWidth;
          const dashWidth = 4.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.grey300),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
