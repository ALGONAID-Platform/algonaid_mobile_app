import 'dart:ui';

import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';

class MoveButtonWidgetAnimated extends StatefulWidget {
  const MoveButtonWidgetAnimated({
    super.key,
    required this.targetProgress,
    required this.onboardinValue,
    required this.isLastPage,
  });

  final OnboardingProvider onboardinValue;
  final double targetProgress;
  final bool isLastPage;

  @override
  State<MoveButtonWidgetAnimated> createState() =>
      _MoveButtonWidgetAnimatedState();
}

class _MoveButtonWidgetAnimatedState extends State<MoveButtonWidgetAnimated> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: widget.targetProgress),
        builder: (context, animatedValue, child) {
          // إذا كان الزر في مرحلة التحول للدائرة، نجعل عرضه 60 دائماً
          final double currentWidth = widget.onboardinValue.isConvertingToCircle
              ? 75
              : (widget.isLastPage ? 205 : 75);

          final double innerWidth = widget.onboardinValue.isConvertingToCircle
              ? 60
              : (widget.isLastPage ? 190 : 60);

          return GestureDetector(
            onTap: () => widget.onboardinValue.goToNextPage(),

            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: currentWidth,
                  height: 75,
                  child: CustomPaint(
                    painter: _UnifiedProgressPainter(
                      progress: animatedValue,
                      progressColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      strokeWidth: 4,
                    ),
                  ),
                ),

                // 2. الزر الداخلي (يتحول لدائرة صلبة)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: innerWidth,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: widget.onboardinValue.isConvertingToCircle
                          ? const SizedBox() // يختفي النص تماماً لتظهر الدائرة فقط
                          : (widget.isLastPage
                                ? const FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "انطلق الآن",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UnifiedProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _UnifiedProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height / 2;
    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // 1. رسم الخلفية (المسار الكامل)
    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, bgPaint);

    // 2. رسم التقدم (كجزء من المسار)
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // إنشاء مسار (Path) للشكل بالكامل ثم استخراج جزء منه بناءً على التقدم
    final Path path = Path()..addRRect(rrect);
    final Path metricPath = _extractPath(path, progress);

    canvas.drawPath(metricPath, progressPaint);
  }

  Path _extractPath(Path source, double progress) {
    final Path path = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      final double extractLen = metric.length * progress;
      path.addPath(metric.extractPath(0, extractLen), Offset.zero);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _UnifiedProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
