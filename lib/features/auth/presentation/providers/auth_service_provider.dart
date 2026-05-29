import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/utils/validations/app_validation.dart';
import 'package:algonaid_mobail_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid_mobail_app/features/auth/domain/usecases/logout_usecase.dart'; // Added
import 'package:flutter/material.dart';

class AuthServiceProvider extends ChangeNotifier {
  final SigninUsecase signInUseCase;
  final SignupUsecase signUpUseCase;
  final LogoutUsecase logoutUseCase; // Added

  AuthServiceProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase, // Added
  });

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLogin = true; // الحالة الافتراضية
  UserRole? _selectedRole = UserRole.student;
  bool _isPasswordVisible = false;
  double? _showPasswordStrength;

  // Getters
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;
  String? get errorMessage => _errorMessage;
  UserRole? get selectedRole => _selectedRole;
  double? get showPasswordStrength => _showPasswordStrength;

  bool? get isPasswordVisible => _isPasswordVisible;

  Future<void> login({required String email, required String password}) async {
    _prepareForRequest();

    final result = await signInUseCase(
      SigninParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;

        notifyListeners();
      },
      (userEntity) async {
        _user = userEntity;
        await cacheUserData(userEntity);
        _errorMessage = null; // التأكد من مسح أي خطأ قديم
        _isLoading = false;
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
      (userEntity) async {
        _user = userEntity;
        await cacheUserData(userEntity);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setRole(UserRole? role) {
    _selectedRole = role;
    notifyListeners();
  }

  void checkPassStrength(String? pass) {
    _showPasswordStrength = Validator.getPasswordStrength(pass!);
    notifyListeners();
  }

  void _prepareForRequest() {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
  }

  void changePasswordVisiblity() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> cacheUserData(UserEntity userEntity) async {
    await CacheHelper.saveData(
      key: AppConstants.userId,
      value: userEntity.id.toString(),
    );
    await CacheHelper.saveData(
      key: AppConstants.userName,
      value: userEntity.username,
    );
    await CacheHelper.saveData(
      key: AppConstants.userEmail,
      value: userEntity.email,
    );
    await CacheHelper.saveData(
      key: AppConstants.userRole,
      value: userEntity.role.code,
    );
    if (userEntity.avatar != null) {
      await CacheHelper.saveData(
        key: AppConstants.userAvatar,
        value: userEntity.avatar!,
      );
    }
    if (userEntity.background != null) {
      await CacheHelper.saveData(
        key: AppConstants.userBackground,
        value: userEntity.background!,
      );
    }
    if (userEntity.academicId != null) {
      await CacheHelper.saveData(
        key: AppConstants.userAcademicId,
        value: userEntity.academicId!,
      );
    }
    if (userEntity.grade != null) {
      await CacheHelper.saveData(
        key: AppConstants.userGrade,
        value: userEntity.grade!,
      );
    }
    if (userEntity.address != null) {
      await CacheHelper.saveData(
        key: AppConstants.userAddress,
        value: userEntity.address!,
      );
    }
    if (userEntity.birthDate != null) {
      await CacheHelper.saveData(
        key: AppConstants.userBirthDate,
        value: userEntity.birthDate!,
      );
    }
    if (userEntity.createdAt != null) {
      await CacheHelper.saveData(
        key: AppConstants.userCreatedAt,
        value: userEntity.createdAt!,
      );
    }
    if (userEntity.updatedAt != null) {
      await CacheHelper.saveData(
        key: AppConstants.userUpdatedAt,
        value: userEntity.updatedAt!,
      );
    }

    final token = userEntity.token?.trim();
    if (token != null && token.isNotEmpty) {
      await TokenStorage.saveToken(token);
    }
  }



  Future<void> logout() async {
    _prepareForRequest();
    
    final result = await logoutUseCase();
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (_) async {
        // Clear cached user data
        await CacheHelper.removeData(key: AppConstants.userName);
        await CacheHelper.removeData(key: AppConstants.userEmail);
        await CacheHelper.removeData(key: AppConstants.userRole);
        await CacheHelper.removeData(key: AppConstants.userAvatar);
        await CacheHelper.removeData(key: AppConstants.userBackground);
        await CacheHelper.removeData(key: AppConstants.userAcademicId);
        await CacheHelper.removeData(key: AppConstants.userGrade);
        await CacheHelper.removeData(key: AppConstants.userAddress);
        await CacheHelper.removeData(key: AppConstants.userBirthDate);
        await CacheHelper.removeData(key: AppConstants.userCreatedAt);
        await CacheHelper.removeData(key: AppConstants.userUpdatedAt);
        await TokenStorage.deleteToken();
        
        _user = null;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
