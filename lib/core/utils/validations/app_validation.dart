import 'dart:core';

import 'package:algonaid/core/common/enums/password_strength.dart';
import 'package:algonaid/core/constants/app_constants.dart';
import 'package:algonaid/core/constants/app_strings.dart';
import 'package:algonaid/core/utils/validations/validation_pattern.dart';

class Validator {
  /// 1. Required Field Validator
  /// Returns null if valid, error message string if invalid
  static String? required(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppString.requiredField}';
    }
    return null;
  }

  /// 2. Email Validator
  static String? email(String value) {
    final trimmedValue = value.trim();
    // Check if empty first
    String? requiredCheck = required(trimmedValue, fieldName: 'البريد الإلكتروني');
    if (requiredCheck != null) return requiredCheck;

    if (!ValidationPatterns.email.hasMatch(trimmedValue)) {
      return AppString.invalidEmail;
    }
    return null;
  }

  /// 3. Saudi Phone Validator
  static String? saudiPhone(String? value) {
    String? requiredCheck = required(value, fieldName: 'رقم الهاتف');
    if (requiredCheck != null) return requiredCheck;

    if (!ValidationPatterns.saudiPhone.hasMatch(value!)) {
      return AppString.invalidSaudiPhone;
    }
    return null;
  }

  /// 4. Password Validator
  static String? password(
    String? value, {
    PasswordStrength strength = PasswordStrength.medium,
  }) {
    String? requiredCheck = required(value, fieldName: 'كلمة المرور');
    if (requiredCheck != null) return requiredCheck;

    final password = value!;

    // Length check
    if (password.length < AppConstants.minPasswordLength) {
      return AppString.passwordTooShort;
    }
    if (password.length > AppConstants.maxPasswordLength) {
      return AppString.passwordTooLong;
    }

    // Strength validation
    switch (strength) {
      case PasswordStrength.weak:
        if (!ValidationPatterns.weakPassword.hasMatch(password)) {
          return AppString.weakPassword;
        }
        break;

      case PasswordStrength.medium:
        if (!ValidationPatterns.mediumPassword.hasMatch(password)) {
          return AppString.mediumPassword;
        }
        break;

      case PasswordStrength.strong:
        // Check all requirements individually for better flexibility
        final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
        final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
        final hasNumber = RegExp(r'\d').hasMatch(password);
        final hasSpecial = RegExp(r'[\W_]').hasMatch(password); // matches any non-alphanumeric char
        
        if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecial) {
          return 'يجب أن تتضمن كلمة المرور حروفاً صغيرة وكبيرة وأرقاماً ورمزاً واحداً على الأقل';
        }
        break;
    }
    return null;
  }

  /// 4. Password Validator
  static double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // 1. فحص الطول (30%)
    if (password.length >= 6) strength += 0.3;
    if (password.length >= 8) strength += 0.1; // بونص للطول الزائد

    // 2. فحص الأحرف الكبيرة والصغيرة (20%)
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      strength += 0.2;
    } else if (RegExp(r'[a-zA-Z]').hasMatch(password)) {
      strength += 0.1; // نوع واحد من الأحرف
    }

    // 3. فحص الأرقام (20%)
    if (RegExp(r'\d').hasMatch(password)) strength += 0.2;

    // 4. فحص الرموز الخاصة (20%)
    if (RegExp(r'[@$!%*?&]').hasMatch(password)) strength += 0.2;

    return strength.clamp(0.0, 1.0); // لضمان عدم تجاوز 100%
  }

  /// 5. Confirm Password Validator
  static String? confirmPassword(String? value, String originalPassword) {
    String? requiredCheck = required(value, fieldName: 'تأكيد كلمة المرور');
    if (requiredCheck != null) return requiredCheck;

    if (value != originalPassword) {
      return AppString.passwordsNotMatch;
    }
    return null;
  }

  /// 6. Length Validator (General Purpose)
  static String? length(
    String? value, {
    int? min,
    int? max,
    int? exact,
    String fieldName = 'الحقل',
  }) {
    String? requiredCheck = required(value, fieldName: fieldName);
    if (requiredCheck != null) return requiredCheck;

    final length = value!.length;

    if (exact != null && length != exact) {
      return '${AppString.exactLength} ($exact)';
    }

    if (min != null && length < min) {
      return '${AppString.minLength} ($min)';
    }

    if (max != null && length > max) {
      return '${AppString.maxLength} ($max)';
    }

    return null;
  }
}
