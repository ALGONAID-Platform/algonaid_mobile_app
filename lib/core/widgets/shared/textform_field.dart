import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  // إضافة متغير للتحكم في اللون أو الحواف إذا أردت تغييرها مستقبلاً
  final Color? borderColor;
  final double borderRadius;

  const CustomTextFormField({
    super.key,
    required this.labelText, // هذا الحقل الوحيد الإجباري
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.borderColor, // قيمة اختيارية
    this.borderRadius = 60.0, // القيمة الافتراضية كما طلبت
  });

  @override
  Widget build(BuildContext context) {
    // تحديد اللون الافتراضي (يمكنك استبدال Colors.blue بلون تطبيقك الأساسي)
    final effectiveBorderColor = borderColor ?? Colors.blue;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onTap: () {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: AppColors
                  .primary, // اختر اللون الذي تريده (مثلاً اللون الأساسي)
              statusBarIconBrightness: Brightness
                  .light, // لجعل الأيقونات (الساعة، البطارية) باللون الأبيض
            ),
          );
        },
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // تطبيق التصميم الافتراضي الذي أرسلته
          border: _buildBorder(effectiveBorderColor, borderRadius),
          enabledBorder: _buildBorder(effectiveBorderColor, borderRadius),
          disabledBorder: _buildBorder(effectiveBorderColor, borderRadius),
          focusedBorder: _buildBorder(
            effectiveBorderColor,
            borderRadius,
            width: 3,
          ),
        ),
      ),
    );
  }

  // دالة خاصة بالبناء لتقليل تكرار الكود
  OutlineInputBorder _buildBorder(
    Color color,
    double radius, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
