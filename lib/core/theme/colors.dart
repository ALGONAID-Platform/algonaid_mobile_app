import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Primary Brand Colors
  static const Color primary = Color(0xFF49BBBD); // Teal (Primary)
  static const Color primaryLight = Color(0xFF60C3C5); // Lighter Teal
  static const Color indigo = Color(0xFF252641); // Deep Navy (Secondary)
  static const Color indigoDark = Color(0xFF1F2138); // Darker Navy

  // Secondary/Accent Colors
  static const Color amber = Color(0xFFFBBF24); // Accent / Highlight
  static const Color red = Color(0xFFE55353); // Error
  static const Color green = Color(0xFF2BB673); // Success

  // Background Colors
  static const Color bgLight = Color.fromARGB(255, 249, 252, 255);
  static const Color bgDark = Color(0xFF19222C);
  static const Color cardDark = Color(0xFF1D2733);
  static const Color surfaceLight = white;
  static const Color surfaceDark = Color(0xFF1F2138);

  // Text Colors
  static const Color textPrimaryBlack = Color(0xFF525252);
  static const Color textPrimaryLight = Color(0xFF4B5563);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = white;
  static const Color textSecondaryDark = Color(0xFFC7D2E5);

  static const Color grey50 = Color(0xFFF7FAFC);
  static const Color grey100 = Color(0xFFF0F5FA);
  static const Color grey200 = Color(0xFFE5EDF4);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF9CA3AF);

  static const Color disabledButton = Color(0xFFE5EDF4);
  static const Color disabledText = Color(0xFF9CA3AF);

  static const Color divider = Color(0xFFE5EDF4);

  static const Color border = Color(0xFF92D6D6);

  static const Color shadow = Color(0x1F000000);

  static const Color overlay = Color(0x66000000);

  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [indigo, indigoDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
