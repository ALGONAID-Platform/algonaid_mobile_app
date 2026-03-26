import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter/material.dart';

class AuthServiceProvider extends ChangeNotifier {
  final SigninUsecase signInUseCase;
  final SignupUsecase signUpUseCase;

  AuthServiceProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
  });

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login({required String email, required String password}) async {
    _prepareForRequest();

    final result = await signInUseCase(
      SigninParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        AppDialog.showDynamicDialog(
          title: "Error",
          isError: true,
          message: failure.message,
        );
        notifyListeners();
      },
      (userEntity) {
        print("===========");
        _user = userEntity;
        _errorMessage = null; // التأكد من مسح أي خطأ قديم
        _isLoading = false;
        AppDialog.showDynamicDialog(
          title: "Hello",
          isError: false,
          message: "successfulu sign in",
        );
        notifyListeners();
        // ملاحظة: التعامل مع رسالة "تم تسجيل الدخول" يفضل أن يكون في الـ UI
      },
    );
  }

  // --- 2. دالة إنشاء الحساب (SignUp) ---
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _prepareForRequest();

    final result = await signUpUseCase(
      SignupParams(
        username: username,
        email: email,
        password: password,
        role: role,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (userEntity) {
        _user = userEntity;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // دالة لتجهيز الحالة قبل أي طلب (Clear error and set loading)
  void _prepareForRequest() {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
