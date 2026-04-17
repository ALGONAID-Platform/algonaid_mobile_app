import 'dart:math';
import 'dart:ui';
import 'package:algonaid_mobail_app/core/theme/colors.dart'; // استيراد ملف الألوان الخاص بك
import 'package:flutter/material.dart';

class Badge3DDialog extends StatefulWidget {
  final String heroTag;
  final String title;
  final String description;
  final Color iconColor;
  final List<Color> gradientColors;
  final Color borderColor;

  const Badge3DDialog({
    super.key,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.gradientColors,
    required this.borderColor,
    required this.heroTag,
  });

  @override
  State<Badge3DDialog> createState() => Badge3DDialogState();
}

class Badge3DDialogState extends State<Badge3DDialog>
    with TickerProviderStateMixin {
  late AnimationController _springController;
  late AnimationController _starController;

  double rotationX = 0;
  double rotationY = 0;

  List<double> _starAngles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _springController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..addListener(() {
          setState(() {
            rotationX = lerpDouble(rotationX, 0, _springController.value)!;
            rotationY = lerpDouble(rotationY, 0, _springController.value)!;
          });
        });

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    _starController.dispose();
    super.dispose();
  }

  void _emitStars() {
    _starAngles = List.generate(12, (index) => _random.nextDouble() * 2 * pi);
    _starController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GestureDetector(
            onPanUpdate: (details) {
              _springController.stop();
              setState(() {
                rotationY += details.delta.dx * 0.01;
                rotationX -= details.delta.dy * 0.01;
              });
            },
            onPanEnd: (details) {
              _springController.forward(from: 0);
              _emitStars();
            },
            child: Material(
              color: Colors.transparent,
              child: Directionality(
                textDirection: TextDirection.rtl, // دعم اللغة العربية
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // تأثير انفجار النجوم
                        AnimatedBuilder(
                          animation: _starController,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: _starAngles.map((angle) {
                                final progress = _starController.value;
                                final distance = progress * 150;
                                final dx = cos(angle) * distance;
                                final dy = sin(angle) * distance;

                                return Transform.translate(
                                  offset: Offset(dx, dy),
                                  child: Opacity(
                                    opacity: 1.0 - progress,
                                    child: Transform.rotate(
                                      angle: progress * pi,
                                      child: const Icon(
                                        Icons.star,
                                        color: AppColors
                                            .amber, // استخدام الـ Amber من ملفك
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        // الوسام ثلاثي الأبعاد
                        Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(rotationX)
                            ..rotateY(rotationY),
                          child: Hero(
                            tag: widget.heroTag,
                            child: _buildBadgeCard(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // العنوان الديناميكي (استخدام ستايل العناوين من الثيم الخاص بك)
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color:
                            AppColors.white, // أبيض دائماً فوق الخلفية المشوشة
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // الوصف الديناميكي (استخدام ستايل النصوص من ملفك)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white.withOpacity(0.85),
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // زر الإغلاق (استخدام ألوان البراند الخاص بك)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors
                              .white, // أو AppColors.grey400 بopacity خفيف
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.grey400,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white.withOpacity(0.9),
            widget.borderColor.withOpacity(0.8),
            widget.borderColor.withOpacity(0.3),
            AppColors.black.withOpacity(0.6),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.gradientColors.last.withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Center(
            child: Icon(Icons.emoji_events, color: widget.iconColor, size: 90),
          ),
        ),
      ),
    );
  }
}
