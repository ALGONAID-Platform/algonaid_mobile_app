
import 'package:flutter/material.dart';


const Duration _kFastMotionDuration = Duration(milliseconds: 200);
const Duration _kMediumMotionDuration = Duration(milliseconds: 300);
const Curve _kStandardMotionCurve = Curves.easeOutCubic;

class AnimatedModuleItem extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedModuleItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final base = _kMediumMotionDuration;
    final extra = Duration(milliseconds: (index % 6) * 40);
    final duration = base + extra;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: _kStandardMotionCurve,
      builder: (context, value, child) {
        final translate = 12 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translate),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
