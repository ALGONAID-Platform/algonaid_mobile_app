import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  // ================= Constants (الثوابت) =================
  static const textStyle40 = TextStyle(
    fontSize: 49,
    fontWeight: FontWeight.bold,
  );

  static const textStyle30 = TextStyle(
    fontSize: 39,
    fontWeight: FontWeight.bold,
  );

  static const textStyle24 = TextStyle(
    fontSize: 31,
    fontWeight: FontWeight.bold,
  );

  static const textStyle20 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const textStyle18 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const textStyle13 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const textStyle12 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  // ================= Helper Methods =================

  
  static TextStyle style24(BuildContext context) {
    return textStyle24.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
    );
  }

  static TextStyle style30(BuildContext context) {
    return textStyle30.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
    );
  }

  static TextStyle style18(BuildContext context) {
    return textStyle18.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
    );
  }

  
  static TextStyle style16(BuildContext context) {
    return textStyle16.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
    );
  }

  static TextStyle style14(BuildContext context) {
    return textStyle14.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
    );
  }

  static TextStyle style12(BuildContext context) {
    return textStyle12.copyWith(
      color:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
    );
  }
}
