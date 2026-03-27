import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final VoidCallback? onSuffixPressed;
  final bool isPasswordVisible; // أزلنا الـ ? وجعلناها مطلوبة أو بقيمة افتراضية
  final bool isPassword; // أزلنا الـ ?
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function()? onTap; // تعديل المسمى من onTap لـ onChanged
  final Color? borderColor;
  final double borderRadius;

  const CustomTextFormField({
    // إضافة const هنا مهمة جداً للأداء
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSuffixPressed,
    this.isPasswordVisible = false, // قيمة افتراضية
    this.isPassword = false, // قيمة افتراضية
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onTap,
    this.borderColor,
    this.borderRadius = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // قراءة الألوان من الثيم مباشرة ليدعم الوضع الليلي
    final effectiveBorderColor =
        borderColor ?? Theme.of(context).colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onTap: onTap,
        obscureText:
            isPassword &&
            !isPasswordVisible, // منطق أكثر دقة لإظهار/إخفاء الباسورد
        validator: validator,
        // أزلنا Directionality لأن فلاتر يتعرف على لغة النظام تلقائياً أو من MaterialApp
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary, // لون الأيقونة من الثيم
                  ),
                  onPressed: onSuffixPressed,
                )
              : suffixIcon,
          border: _buildBorder(effectiveBorderColor, borderRadius),
          enabledBorder: _buildBorder(
            effectiveBorderColor.withOpacity(0.5),
            borderRadius,
          ), // حواف أخف عند عدم التفاعل
          focusedBorder: _buildBorder(
            effectiveBorderColor,
            borderRadius,
            width: 2,
          ),
          errorBorder: _buildBorder(
            Theme.of(context).colorScheme.error,
            borderRadius,
          ),
        ),
      ),
    );
  }

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
