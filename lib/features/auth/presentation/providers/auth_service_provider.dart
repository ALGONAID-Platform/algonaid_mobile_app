import 'dart:io' show Platform;
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:algonaid/core/common/enums/user_role.dart';
import 'package:algonaid/core/constants/app_constants.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:algonaid/core/utils/hive/init_hive.dart';
import 'package:algonaid/core/utils/validations/app_validation.dart';
import 'package:algonaid/features/auth/domain/entities/user_entity.dart';
import 'package:algonaid/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/signin_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/signup_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/logout_usecase.dart'; // Added
import 'package:algonaid/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:algonaid/features/auth/domain/usecases/resend_verification_usecase.dart';
import 'package:algonaid/features/auth/data/models/auth_models.dart';
import 'package:algonaid/core/network/api_service.dart';
import 'package:algonaid/core/constants/endpoints.dart';
import 'package:algonaid/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceProvider extends ChangeNotifier {
  final SigninUsecase signInUseCase;
  final GoogleSigninUsecase googleSignInUseCase;
  final SignupUsecase signUpUseCase;
  final LogoutUsecase logoutUseCase; // Added
  final ForgotPasswordUsecase forgotPasswordUseCase;
  final ResetPasswordUsecase resetPasswordUseCase;
  final VerifyEmailUsecase verifyEmailUseCase;
  final ResendVerificationUsecase resendVerificationUseCase;

  AuthServiceProvider({
    required this.signInUseCase,
    required this.googleSignInUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase, // Added
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.verifyEmailUseCase,
    required this.resendVerificationUseCase,
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
        _user = null; // تأكد من مسح المستخدم في حال الفشل
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
      (userEntity) {
        _user = userEntity;
        _errorMessage = null;
        // حفظ البيانات في الخلفية دون انتظار
        cacheUserData(userEntity).catchError((e) {
          debugPrint('⚠️ SignUp: خطأ أثناء حفظ بيانات المستخدم: $e');
        });
        if (userEntity.token != null && userEntity.token!.isNotEmpty) {
          debugPrint('✅ SignUp: تم تعيين المستخدم والتوكن بنجاح.');
        } else {
          debugPrint('⚠️ SignUp: السيرفر لم يُرجع توكن.');
        }
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
      _errorMessage = "حدث خطأ غير متوقع أثناء معالجة تسجيل الدخول بجوجل";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _prepareForRequest();
    try {
      final googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS
            ? '384073856983-fshcgklqtg7fk3kuu7tonnbbfq0k6281.apps.googleusercontent.com'
            : null,
        serverClientId:
            '384073856983-j4h4lvqbgurl07ecd3nhd1bf0btuq6js.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );

      // ── خطوة 1: مسح أي جلسة سابقة ──────────────────────────────────
      // نتحقق من وجود جلسة Firebase سابقة أو جلسة Google ونحذفها
      // لضمان ظهور نافذة اختيار الحسابات في كل مرة
      try {
        final currentFirebaseUser = FirebaseAuth.instance.currentUser;
        if (currentFirebaseUser != null) {
          debugPrint('🔄 Google Sign-In: جلسة Firebase سابقة موجودة، يتم حذفها...');
          await FirebaseAuth.instance.signOut();
        }
        final isSignedInGoogle = await googleSignIn.isSignedIn();
        if (isSignedInGoogle) {
          debugPrint('🔄 Google Sign-In: جلسة Google سابقة موجودة، يتم حذفها...');
          await googleSignIn.signOut();
        }
        debugPrint('✅ Google Sign-In: تم التأكد من عدم وجود جلسات سابقة.');
      } catch (signOutError) {
        // إذا فشل تسجيل الخروج، نستمر على أي حال
        debugPrint('⚠️ Google Sign-In: خطأ أثناء مسح الجلسة السابقة: $signOutError');
      }
      // ─────────────────────────────────────────────────────────────────

      final account = await googleSignIn.signIn();


      if (account == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final auth = await account.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase authentication failed.');
      }

      final firebaseIdToken = await firebaseUser.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.trim().isEmpty) {
        throw Exception('Firebase ID token is missing.');
      }

      final result = await googleSignInUseCase(
        GoogleSigninParams(idToken: firebaseIdToken),
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
        },
        (userEntity) async {
          final avatarUrl = (userEntity.avatar != null && userEntity.avatar!.isNotEmpty) 
              ? userEntity.avatar 
              : account.photoUrl;
              
          final updatedUserEntity = UserEntity(
            id: userEntity.id,
            username: userEntity.username,
            email: userEntity.email,
            role: userEntity.role,
            message: userEntity.message,
            token: userEntity.token,
            avatar: avatarUrl,
            background: userEntity.background,
            academicId: userEntity.academicId,
            grade: userEntity.grade,
            birthDate: userEntity.birthDate,
            address: userEntity.address,
            createdAt: userEntity.createdAt,
            updatedAt: userEntity.updatedAt,
          );
          
          _user = updatedUserEntity;
          await cacheUserData(updatedUserEntity);
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      String errorDetails = 'Error Type: ${e.runtimeType}\nError: $e';
      if (e is FirebaseAuthException) {
        errorDetails += '\nFirebaseAuthException Code: ${e.code}\nMessage: ${e.message}';
      } else if (e is PlatformException) {
        errorDetails += '\nPlatformException Code: ${e.code}\nMessage: ${e.message}\nDetails: ${e.details}';
      }
      
      developer.log('❌ Google Sign-In Failed', error: e, stackTrace: stackTrace, name: 'AuthServiceGoogleSignIn');
      debugPrint('❌ Google Sign-In Error Details: $errorDetails');
      debugPrint('📋 Stack Trace: $stackTrace');
      
      _errorMessage = "تفاصيل خطأ تسجيل الدخول بجوجل:\n$errorDetails\nالتتبع: $stackTrace";
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
    
    await CacheHelper.clearByPrefix('last_lesson_course_');
    await CacheHelper.clearByPrefix('last_module_course_');
    await CacheHelper.clearByPrefix(AppConstants.cacheModuleGradesPrefix);

    await clearAllUserHiveData();
    _user = null;
    notifyListeners();
  }

  Future<void> logout() async {
    _prepareForRequest();

    final result = await logoutUseCase();

    await result.fold(
      (failure) async {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (_) async {
        try {
          await GoogleSignIn().signOut();
        } catch (_) {}
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

  // ==================== Email Verification ====================
  bool _isEmailVerificationSuccess = false;
  bool get isEmailVerificationSuccess => _isEmailVerificationSuccess;

  Future<bool> verifyEmail(String token) async {
    _prepareForRequest();
    _isEmailVerificationSuccess = false;
    final result = await verifyEmailUseCase(VerifyEmailParams(token: token));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (message) {
        _errorMessage = null;
        _isLoading = false;
        _isEmailVerificationSuccess = true;
        notifyListeners();
        return true;
      },
    );
  }

  // ==================== Validate Reset Token ====================
  /// يتحقق من صلاحية توكن إعادة التعيين قبل إظهار الصفحة
  Future<bool> validateResetToken(String token) async {
    try {
      final apiService = getIt<ApiService>();
      await apiService.get(
        endpoint: EndPoint.validateResetToken,
        query: {'token': token},
      );
      return true;
    } catch (_) {
      return false;
    }
  }


  Future<bool> resendVerificationEmail(String email) async {
    _prepareForRequest();
    final result = await resendVerificationUseCase(ResendVerificationParams(email: email));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (message) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
