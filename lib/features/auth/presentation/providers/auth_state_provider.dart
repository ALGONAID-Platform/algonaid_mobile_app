import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:flutter/material.dart';

class AuthStateProvider extends ChangeNotifier {
  bool _isLogin = true; // الحالة الافتراضية
  bool _isLoading = false;
  UserRole? _selectedRole;

  // Getters للوصول للقيم
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  UserRole? get selectedRole => _selectedRole;

  // تبديل الوضع بين دخول وإنشاء حساب
  toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners(); // إشعار الواجهة بالتغيير
  }

  setRole(UserRole? role) {
    _selectedRole = role;
    notifyListeners();
  }

  // محاكاة عملية الإرسال للسيرفر
  Future<void> submitAuth() async {
    _isLoading = true;
    notifyListeners();

    // // محاكاة تأخير الشبكة (مثلاً للاتصال بـ NestJS لاحقاً)
    // await Future.delayed(const Duration(seconds: 2));

    // _isLoading = false;
    // notifyListeners();
  }
}
