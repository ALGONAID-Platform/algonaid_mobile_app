import 'package:algonaid_mobile_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobile_app/core/utils/validations/app_validation.dart';
import 'package:algonaid_mobile_app/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid_mobile_app/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/usecases/logout_usecase.dart'; // Added
import 'package:algonaid_mobile_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:algonaid_mobile_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:algonaid_mobile_app/features/auth/data/models/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthServiceProvider extends ChangeNotifier {
  final SigninUsecase signInUseCase;
  final GoogleSigninUsecase googleSignInUseCase;
  final SignupUsecase signUpUseCase;
  final LogoutUsecase logoutUseCase; // Added
  final ForgotPasswordUsecase forgotPasswordUseCase;
  final ResetPasswordUsecase resetPasswordUseCase;

  AuthServiceProvider({
    required this.signInUseCase,
    required this.googleSignInUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase, // Added
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
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

  Future<void> restoreSession() async {
    final token = TokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    try {
      if (token.contains('.') && JwtDecoder.isExpired(token)) {
        await _clearCachedSession();
        return;
      }
    } catch (_) {
      // If the JWT cannot be decoded, keep the token and let the API validate it.
    }

    final restoredUser =
        _buildUserFromCache(token) ?? _buildUserFromToken(token);
    if (restoredUser != null) {
      _user = restoredUser;
      notifyListeners();
    }
  }

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

  Future<void> loginWithGoogleResponse(
    Map<String, dynamic> responseData,
  ) async {
    _prepareForRequest();
    try {
      final authResponse = AuthResponse.fromJson(responseData);
      final userEntity = UserEntity(
        id: authResponse.user.id,
        username: authResponse.user.name,
        email: authResponse.user.email,
        role: authResponse.user.role,
        message: authResponse.message,
        token: authResponse.accessToken,
        avatar: authResponse.user.avatar,
        background: authResponse.user.background,
        academicId: authResponse.user.academicId,
        grade: authResponse.user.grade,
        birthDate: authResponse.user.birthDate,
        address: authResponse.user.address,
        createdAt: authResponse.user.createdAt,
        updatedAt: authResponse.user.updatedAt,
      );
      _user = userEntity;
      await cacheUserData(userEntity);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _prepareForRequest();
    try {
      final googleSignIn = GoogleSignIn(
        clientId:
            '891038928378-o7m1sealgkogiaolpuaisspg22g2c1i5.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
      final account = await googleSignIn.signIn();

      if (account == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final auth = await account.authentication;
      final accessToken = auth.accessToken;
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw Exception('Google access token is missing.');
      }

      final result = await googleSignInUseCase(
        GoogleSigninParams(accessToken: accessToken),
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
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void setAuthMode(bool isLogin) {
    if (_isLogin != isLogin) {
      _isLogin = isLogin;
      notifyListeners();
    }
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

  UserEntity? _buildUserFromCache(String token) {
    final userId = CacheHelper.getString(key: AppConstants.userId);
    final userName = CacheHelper.getString(key: AppConstants.userName);
    final userEmail = CacheHelper.getString(key: AppConstants.userEmail);
    final userRole = CacheHelper.getString(key: AppConstants.userRole);

    if (userId == null ||
        userName == null ||
        userEmail == null ||
        userRole == null) {
      return null;
    }

    final parsedRole = UserRole.values.firstWhere(
      (role) => role.code.toUpperCase() == userRole.toUpperCase(),
      orElse: () => UserRole.student,
    );

    return UserEntity(
      id: int.tryParse(userId) ?? 0,
      username: userName,
      email: userEmail,
      role: parsedRole,
      message: '',
      token: token,
      avatar: CacheHelper.getString(key: AppConstants.userAvatar),
      background: CacheHelper.getString(key: AppConstants.userBackground),
      academicId: CacheHelper.getString(key: AppConstants.userAcademicId),
      grade: CacheHelper.getString(key: AppConstants.userGrade),
      birthDate: CacheHelper.getString(key: AppConstants.userBirthDate),
      address: CacheHelper.getString(key: AppConstants.userAddress),
      createdAt: CacheHelper.getString(key: AppConstants.userCreatedAt),
      updatedAt: CacheHelper.getString(key: AppConstants.userUpdatedAt),
    );
  }

  UserEntity? _buildUserFromToken(String token) {
    if (!token.contains('.')) {
      return null;
    }

    try {
      final payload = JwtDecoder.decode(token);
      final userId = payload['id'];
      final email = payload['email']?.toString();
      final roleValue = payload['role']?.toString();

      if (userId == null || email == null) {
        return null;
      }

      final parsedRole = UserRole.values.firstWhere(
        (role) => role.code.toUpperCase() == roleValue?.toUpperCase(),
        orElse: () => UserRole.student,
      );

      return UserEntity(
        id: int.tryParse(userId.toString()) ?? 0,
        username: CacheHelper.getString(key: AppConstants.userName) ?? email,
        email: email,
        role: parsedRole,
        message: '',
        token: token,
        avatar: CacheHelper.getString(key: AppConstants.userAvatar),
        background: CacheHelper.getString(key: AppConstants.userBackground),
        academicId: CacheHelper.getString(key: AppConstants.userAcademicId),
        grade: CacheHelper.getString(key: AppConstants.userGrade),
        birthDate: CacheHelper.getString(key: AppConstants.userBirthDate),
        address: CacheHelper.getString(key: AppConstants.userAddress),
        createdAt: CacheHelper.getString(key: AppConstants.userCreatedAt),
        updatedAt: CacheHelper.getString(key: AppConstants.userUpdatedAt),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearCachedSession() async {
    await TokenStorage.deleteToken();
    await CacheHelper.removeData(key: AppConstants.userId);
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
    _user = null;
    notifyListeners();
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
        await _clearCachedSession();
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<String?> forgotPassword({required String email}) async {
    _prepareForRequest();
    final result = await forgotPasswordUseCase(
      ForgotPasswordParams(email: email),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (message) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return message;
      },
    );
  }

  Future<String?> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _prepareForRequest();
    final result = await resetPasswordUseCase(
      ResetPasswordParams(token: token, newPassword: newPassword),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (message) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return message;
      },
    );
  }
}
