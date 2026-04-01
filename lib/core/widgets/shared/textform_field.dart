import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final VoidCallback? onSuffixPressed;
  final bool isPasswordVisible;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Color? borderColor;
  final double borderRadius;
  final Function(String)? onChanged;

  // --- الحقول الجديدة للتحكم في التعبئة ---
  final double fillPercentage; // من 0.0 إلى 1.0
  final Color? fillColorValue; // اللون (أحمر، برتقالي، أخضر)

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSuffixPressed,
    this.isPasswordVisible = false,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onTap,
    this.onChanged,
    this.borderColor,
    this.borderRadius = 60.0,
    this.fillPercentage = 0.5, // افتراضياً لا يوجد تعبئة
    this.fillColorValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? Theme.of(context).colorScheme.primary;

    // تحديد لون التعبئة الافتراضي (أخضر شفاف مثلاً)
    final progressColor = fillColorValue ?? AppColors.green.withOpacity(0.2);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: fillPercentage),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Container(
                height: 60, // هذا الارتفاع يطابق ارتفاع الحقل الافتراضي تقريباً
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: isPassword
                      ? LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            progressColor,
                            progressColor,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: [0.0, value, value, 1.0],
                        )
                      : null,
                ),
              );
            },
          ),
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            keyboardType: keyboardType,
            onTap: onTap,

            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              filled: isPassword ? true : false,
              fillColor: isPassword
                  ? Colors.transparent
                  : null, // جعل الخلفية شفافة لرؤية التدرج
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: labelText,
              labelStyle: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.45),
              ),
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: onSuffixPressed,
                    )
                  : suffixIcon,
              border: _buildBorder(effectiveBorderColor, borderRadius),
              enabledBorder: _buildBorder(
                effectiveBorderColor.withOpacity(0.5),
                borderRadius,
              ),
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
        ],
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
