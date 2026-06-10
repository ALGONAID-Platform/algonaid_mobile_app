// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobile_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:algonaid_mobile_app/core/network/api_service.dart';
import 'package:algonaid_mobile_app/features/auth/data/models/auth_models.dart';

abstract class AuthRemoteDatasourse {
  Future<AuthResponse> signin({
    required String email,
    required String password,
  });
  Future<AuthResponse> signup({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<AuthResponse> googleSignin({required String accessToken});
  Future<void> logout(); // Added
  Future<Map<String, dynamic>> forgotPassword({required String email});
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  });
}

class AuthRemoteDatasourseImp extends AuthRemoteDatasourse {
  final ApiService apiService;

  AuthRemoteDatasourseImp({required this.apiService});
  @override
  Future<AuthResponse> signin({
    required String email,
    required String password,
  }) async {
    var user = await apiService.post(
      endpoint: EndPoint.signin,
      data: {'email': email, 'password': password},
    );
    return AuthResponse.fromJson(user);
  }

  @override
  Future<AuthResponse> signup({
    required String username,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    print(role.code);
    var user = await apiService.post(
      endpoint: EndPoint.signup,
      data: {
        'name': username,
        'email': email,
        'password': password,
        'role': role.code,
      },
    );

    return AuthResponse.fromJson(user);
  }

  @override
  Future<AuthResponse> googleSignin({required String accessToken}) async {
    final user = await apiService.post(
      endpoint: EndPoint.googleMobileAuth,
      data: {'accessToken': accessToken},
    );

    return AuthResponse.fromJson(user);
  }

  @override
  Future<void> logout() async {
    await apiService.post(endpoint: EndPoint.logout, data: {});
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await apiService.post(
      endpoint: EndPoint.forgotPassword,
      data: {'email': email},
    );
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await apiService.post(
      endpoint: EndPoint.resetPassword,
      data: {'token': token, 'newPassword': newPassword},
    );
    return Map<String, dynamic>.from(response);
  }
}
