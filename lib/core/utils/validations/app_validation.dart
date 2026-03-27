import 'dart:core';

import 'package:algonaid_mobail_app/core/common/enums/password_strength.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/constants/app_strings.dart';
import 'package:algonaid_mobail_app/core/utils/validations/validation_pattern.dart';


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
    // Check if empty first
    String? requiredCheck = required(value, fieldName: 'البريد الإلكتروني');
    if (requiredCheck != null) return requiredCheck;

    if (!ValidationPatterns.email.hasMatch(value)) {
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
        if (!ValidationPatterns.strongPassword.hasMatch(password)) {
          // Detailed breakdown if strict regex fails
          if (!RegExp(r'[A-Z]').hasMatch(password)) {
            return AppString.passwordNoUppercase;
          }
          if (!RegExp(r'[a-z]').hasMatch(password)) {
            return AppString.passwordNoLowercase;
          }
          if (!RegExp(r'\d').hasMatch(password)) {
            return AppString.passwordNoNumber;
          }
          if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
            return AppString.passwordNoSpecialChar;
          }
          // Default fallback
          return AppString.strongPassword;
        }
        break;
    }
    return null;
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