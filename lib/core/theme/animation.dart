
import 'dart:math';

import 'package:flutter/material.dart';

class MathBackground extends StatefulWidget {
  @override
  _MathBackgroundState createState() => _MathBackgroundState();
}

class _MathBackgroundState extends State<MathBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<MathSymbol> symbols = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // سرعة الحركة الإجمالية
      vsync: this,
    )..repeat();

    List<String> mathIcons = [
      '∑',
      'π',
      '∞',
      '√',
      '∫',
      '∆',
      '≈',
      'f(x)',
      'θ',
      'λ',
    ];
    for (int i = 0; i < 15; i++) {
      symbols.add(
        MathSymbol(
          text: mathIcons[random.nextInt(mathIcons.length)],
          top: random.nextDouble(),
          left: random.nextDouble(),
          size: 20.0 + random.nextInt(30),
          speed: 0.5 + random.nextDouble(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: symbols.map((symbol) {
            // تحريك الرموز للأعلى باستمرار
            double currentTop =
                (symbol.top - (_controller.value * symbol.speed)) % 1.0;
            return Positioned(
              top: currentTop * MediaQuery.of(context).size.height,
              left: symbol.left * MediaQuery.of(context).size.width,
              child: Opacity(
                opacity: 0.08, // شفافية خفيفة جداً لكي لا يزعج النص
                child: Text(
                  symbol.text,
                  style: TextStyle(
                    fontSize: symbol.size,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // أو استخدم AppColors.primary
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class MathSymbol {
  final String text;
  final double top;
  final double left;
  final double size;
  final double speed;

  MathSymbol({
    required this.text,
    required this.top,
    required this.left,
    required this.size,
    required this.speed,
  });
}
