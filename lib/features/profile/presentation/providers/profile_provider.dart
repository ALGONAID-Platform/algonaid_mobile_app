import 'package:flutter/material.dart';
import '../../domain/usecases/get_total_points_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileProvider extends ChangeNotifier {
  final GetTotalPointsUseCase getTotalPointsUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileProvider({
    required this.getTotalPointsUseCase,
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  });

  bool _isLoadingPoints = false;
  bool get isLoadingPoints => _isLoadingPoints;

  int _totalPoints = 0;
  int get totalPoints => _totalPoints;

  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  bool _isUpdatingProfile = false;
  bool get isUpdatingProfile => _isUpdatingProfile;

  UserProfileEntity? _userProfile;
  UserProfileEntity? get userProfile => _userProfile;

  String? _error;
  String? get error => _error;

  Future<void> loadTotalPoints() async {
    _isLoadingPoints = true;
    _error = null;
    notifyListeners();

    final result = await getTotalPointsUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        debugPrint('Error loading points: ${failure.message}');
      },
      (data) {
        _totalPoints = data.totalPoints;
      },
    );

    _isLoadingPoints = false;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    _isLoadingProfile = true;
    _error = null;
    notifyListeners();

    final result = await getUserProfileUseCase();
    result.fold(
      (failure) {
        _error = failure.message;
        debugPrint('Error loading profile: ${failure.message}');
      },
      (profile) {
        _userProfile = profile;
      },
    );

    _isLoadingProfile = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    _isUpdatingProfile = true;
    _error = null;
    notifyListeners();

    final result = await updateUserProfileUseCase(data);
    bool success = false;
    result.fold(
      (failure) {
        _error = failure.message;
        debugPrint('Error updating profile: ${failure.message}');
      },
      (profile) {
        _userProfile = profile;
        success = true;
      },
    );

    _isUpdatingProfile = false;
    notifyListeners();
    return success;
  }
}
