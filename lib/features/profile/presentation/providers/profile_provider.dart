import 'package:flutter/material.dart';
import '../../domain/usecases/get_total_points_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/get_user_badges_usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/user_badge_entity.dart';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/utils/notification_service.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/utils/badges_helper.dart';

class ProfileProvider extends ChangeNotifier {
  final GetTotalPointsUseCase getTotalPointsUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final GetUserBadgesUseCase getUserBadgesUseCase;

  ProfileProvider({
    required this.getTotalPointsUseCase,
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.getUserBadgesUseCase,
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

  bool _isLoadingBadges = false;
  bool get isLoadingBadges => _isLoadingBadges;

  List<UserBadgeEntity> _userBadges = [];
  List<UserBadgeEntity> get userBadges => _userBadges;

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
        // Keep AppConstants cache in sync
        CacheHelper.saveData(key: AppConstants.userName, value: profile.name);
        if (profile.avatar != null) {
          CacheHelper.saveData(
            key: AppConstants.userAvatar,
            value: profile.avatar!,
          );
        }
        if (profile.background != null) {
          CacheHelper.saveData(
            key: AppConstants.userBackground,
            value: profile.background!,
          );
        }
        if (profile.grade != null) {
          CacheHelper.saveData(
            key: AppConstants.userGrade,
            value: profile.grade!,
          );
        }
        if (profile.address != null) {
          CacheHelper.saveData(
            key: AppConstants.userAddress,
            value: profile.address!,
          );
        }
        if (profile.birthDate != null) {
          CacheHelper.saveData(
            key: AppConstants.userBirthDate,
            value: profile.birthDate!,
          );
        }
      },
    );

    _isLoadingProfile = false;
    notifyListeners();
  }

  Future<void> loadUserBadges() async {
    _isLoadingBadges = true;
    _error = null;
    notifyListeners();

    final result = await getUserBadgesUseCase();
    await result.fold(
      (failure) async {
        _error = failure.message;
        debugPrint('Error loading badges: ${failure.message}');
      },
      (badges) async {
        _userBadges = badges;

        // Check for newly unlocked badges
        final unlockedKeys =
            CacheHelper.getStringList(key: 'unlocked_badge_keys') ?? [];
        final newUnlockedKeys = List<String>.from(unlockedKeys);
        bool newlyUnlocked = false;

        final badgeEntities = BadgesHelper.getBadges(badges);
        for (final badge in badgeEntities) {
          if (badge.isUnlocked && !unlockedKeys.contains(badge.key)) {
            newUnlockedKeys.add(badge.key);
            newlyUnlocked = true;
            // Send local notification & play sound
            await NotificationService().showNotification(
              title: 'لقد حصلت على وسام جديد! 🏆',
              body:
                  'تهانينا! لقد تم منحك "${badge.title}". ${badge.requirementText}',
            );
          }
        }

        if (newlyUnlocked) {
          await CacheHelper.saveData(
            key: 'unlocked_badge_keys',
            value: newUnlockedKeys,
          );
        }
      },
    );

    _isLoadingBadges = false;
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
        // Keep AppConstants cache in sync
        CacheHelper.saveData(key: AppConstants.userName, value: profile.name);
        if (profile.avatar != null) {
          CacheHelper.saveData(
            key: AppConstants.userAvatar,
            value: profile.avatar!,
          );
        }
        if (profile.background != null) {
          CacheHelper.saveData(
            key: AppConstants.userBackground,
            value: profile.background!,
          );
        }
        if (profile.grade != null) {
          CacheHelper.saveData(
            key: AppConstants.userGrade,
            value: profile.grade!,
          );
        }
        if (profile.address != null) {
          CacheHelper.saveData(
            key: AppConstants.userAddress,
            value: profile.address!,
          );
        }
        if (profile.birthDate != null) {
          CacheHelper.saveData(
            key: AppConstants.userBirthDate,
            value: profile.birthDate!,
          );
        }
      },
    );

    _isUpdatingProfile = false;
    notifyListeners();
    return success;
  }
}
