import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GreenRevealPage extends CustomTransitionPage {
  GreenRevealPage({
    required LocalKey key,
    required Widget child,
    required Offset center,
    Color color = Colors.green,
  }) : super(
         key: key,
         child: child,
         transitionDuration: const Duration(milliseconds: 2000),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final colorCurve = CurvedAnimation(
             parent: animation,
             curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCirc),
           );

           final pageCurve = CurvedAnimation(
             parent: animation,
             curve: const Interval(0.3, 1.0, curve: Curves.easeInOutCirc),
           );

           return Stack(
             children: [
               AnimatedBuilder(
                 animation: colorCurve,
                 builder: (context, _) {
                   return ClipPath(
                     clipper: CircleRevealClipper(colorCurve.value, center),
                     child: Container(color: color),
                   );
                 },
               ),

               AnimatedBuilder(
                 animation: pageCurve,
                 builder: (context, _) {
                   return ClipPath(
                     clipper: CircleRevealClipper(pageCurve.value, center),
                     child: child,
                   );
                 },
               ),
             ],
           );
         },
       );
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double progress;
  final Offset center;

  CircleRevealClipper(this.progress, this.center);

  @override
  Path getClip(Size size) {
    double maxRadius = sqrt(
      size.width * size.width + size.height * size.height,
    );

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * progress));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
