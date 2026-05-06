







import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
           color: context.primary
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              const SizedBox(height: 14),
              const Text(
                "مرحباً بك في رحلتك التعليمية ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "لا يوجد درس حالياً، لكن هذه هي البداية المثالية \n"
                "ابدأ مسارك خطوة بخطوة نحو التعلّم والإنجاز.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              const _StartButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white70,
          width: 1.2,
        ),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white.withOpacity(0.08), // 🔥 شفاف
      ),
      child: const Text(
        "ابدأ التعلم الآن",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}