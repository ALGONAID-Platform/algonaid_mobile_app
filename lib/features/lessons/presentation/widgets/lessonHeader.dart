import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid/core/widgets/shared/heroWidget.dart';
import 'package:algonaid/core/widgets/shared/linearProgress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/features/modules/presentation/providers/module_grades_provider.dart';
import 'package:algonaid/features/modules/presentation/widgets/module_grades_widget.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/di/service_locator.dart';
import 'package:algonaid/core/widgets/shared/app_bottom_sheet.dart';
import 'package:marquee/marquee.dart' as marquee;

class ModuleHeaderStats extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final String? moduleDescription;
  final VoidCallback? onBack;
  const ModuleHeaderStats({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.moduleDescription,
    this.onBack,
  });

  @override
  State<ModuleHeaderStats> createState() => _ModuleHeaderStatsState();
}

class _ModuleHeaderStatsState extends State<ModuleHeaderStats> with SingleTickerProviderStateMixin {
  late ModuleGradesProvider _gradesProvider;
  bool _isDescriptionExpanded = false;
  late AnimationController _arrowAnimationController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    // We obtain the provider but do NOT fetch here.
    // Fetching happens inside ModuleGradesWidget when the user presses the button.
    _gradesProvider = getIt<ModuleGradesProvider>();
    _arrowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _arrowAnimation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _arrowAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gradesProvider,
      child: Consumer<ModuleGradesProvider>(
        builder: (context, provider, child) {
          // Read cached state if available — no fetch triggered here.
          final state = provider.getState(widget.moduleId);
          final isUnlocked = (state.grades?.averagePercentage ?? 0.0) >= 85;

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: Builder(
                          builder: (context) {
                            final title = widget.moduleTitle;
                            final style = context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ?? const TextStyle();
                            
                            if (title.length > 20) {
                              return SizedBox(
                                height: 35,
                                child: marquee.Marquee(
                                  text: title,
                                  style: style,
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 30.0,
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 2),
                                  startPadding: 10.0,
                                  textDirection: TextDirection.rtl,
                                ),
                              );
                            }
                            return Text(
                              title,
                              style: style,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
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
                              : "أنت على بُعد خطوة من التميّز! ستحصل على وسام البراعة الفضي عند اجتيازك لجميع اختبارات هذه الوحدة بنسبة %85 أو أكثر. أثبت مهاراتك الآن!",
                          lottie: AppLottie.goldMedal2, // We might need a silver medal here if we have one, but keeping it as is.
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
                                  'يتطلب الحصول على درجة 85% أو أعلى في اختبارات الوحدة.',
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
                                if (widget.moduleDescription != null && widget.moduleDescription!.isNotEmpty) ...[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isDescriptionExpanded = !_isDescriptionExpanded;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "وصف الوحدة",
                                            style: theme.textTheme.labelMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.onBackground.withOpacity(0.7),
                                            ),
                                          ),
                                          AnimatedBuilder(
                                            animation: _arrowAnimation,
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: Offset(0, _isDescriptionExpanded ? 0 : _arrowAnimation.value),
                                                child: Icon(
                                                  _isDescriptionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                  color: theme.colorScheme.primary,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_isDescriptionExpanded) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.moduleDescription!,
                                      style: theme.textTheme.bodyMedium,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                  const SizedBox(height: 20),
                                ],
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
                                // الزر يظهر دائماً — التحميل يحدث فقط داخل الـ bottom sheet
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
