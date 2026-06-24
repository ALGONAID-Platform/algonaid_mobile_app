import 'package:flutter/material.dart';
import '../../domain/usecases/get_total_points_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/get_user_badges_usecase.dart';
import '../../domain/usecases/get_cached_user_badges_usecase.dart';
import '../../domain/usecases/get_cached_user_profile_usecase.dart';
import '../../domain/usecases/get_cached_total_points_usecase.dart';
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
  final GetCachedUserBadgesUseCase getCachedUserBadgesUseCase;
  final GetCachedUserProfileUsecase getCachedUserProfileUsecase;
  final GetCachedTotalPointsUsecase getCachedTotalPointsUsecase;

  ProfileProvider({
    required this.getTotalPointsUseCase,
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.getUserBadgesUseCase,
    required this.getCachedUserBadgesUseCase,
    required this.getCachedUserProfileUsecase,
    required this.getCachedTotalPointsUsecase,
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

  bool _isBackgroundUpdating = false;
  bool get isBackgroundUpdating => _isBackgroundUpdating;

  List<UserBadgeEntity> _userBadges = [];
  List<UserBadgeEntity> get userBadges => _userBadges;

  String? _error;
  String? get error => _error;

  Future<void> loadTotalPoints() async {
    // 1. Load from cache first
    final cachedResult = getCachedTotalPointsUsecase();
    cachedResult.fold(
      (failure) {},
      (data) {
        _totalPoints = data.totalPoints;
        notifyListeners();
      },
    );

    // 2. Fetch from remote if cache is empty
    if (_totalPoints == 0) {
      _isLoadingPoints = true;
      _isBackgroundUpdating = false;
      _error = null;
      notifyListeners();
    } else {
      _isBackgroundUpdating = true;
      notifyListeners();
    }

    final result = await getTotalPointsUseCase();

    result.fold(
      (failure) {
        _error = _totalPoints == 0 ? failure.message : null;
        debugPrint('Error loading points: ${failure.message}');
      },
      (data) {
        _totalPoints = data.totalPoints;
      },
    );

    _isLoadingPoints = false;
    _isBackgroundUpdating = false;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    // 1. Load from cache first
    final cachedResult = getCachedUserProfileUsecase();
    cachedResult.fold(
      (failure) {},
      (profile) {
        _userProfile = profile;
        notifyListeners();
      },
    );

    // 2. Load from remote if cache is empty
    if (_userProfile == null) {
      _isLoadingProfile = true;
      _isBackgroundUpdating = false;
      _error = null;
      notifyListeners();
    } else {
      _isBackgroundUpdating = true;
      notifyListeners();
    }

    final result = await getUserProfileUseCase();
    result.fold(
      (failure) {
        _error = _userProfile == null ? failure.message : null;
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
    _isBackgroundUpdating = false;
    notifyListeners();
  }

  Future<void> loadUserBadges({bool forceRefresh = false}) async {
    // 1. تحميل الكاش فوراً لتجنب مؤشر التحميل إذا كانت البيانات موجودة
    final cachedResult = getCachedUserBadgesUseCase();
    cachedResult.fold(
      (failure) => debugPrint('Error loading cached badges: ${failure.message}'),
      (badges) {
        if (badges.isNotEmpty) {
          _userBadges = badges;
        }
      },
    );

    // 2. تفعيل مؤشر التحميل فقط إذا لم تكن هناك أوسمة في الكاش
    final hasCache = _userBadges.isNotEmpty;

    // إذا كان هناك كاش ولم يُطلب تحديث إجباري، نعرض الكاش فقط دون جلب من السيرفر
    if (hasCache && !forceRefresh) {
      _isLoadingBadges = false;
      _isBackgroundUpdating = false;
      notifyListeners();
      return;
    }

    if (!hasCache) {
      _isLoadingBadges = true;
      _isBackgroundUpdating = false;
      _error = null;
      notifyListeners();
    } else {
      _isBackgroundUpdating = true;
      notifyListeners();
    }

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
    _isBackgroundUpdating = false;
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

  void clearProfileData() {
    _userProfile = null;
    _totalPoints = 0;
    _userBadges = [];
    _error = null;
    notifyListeners();
  }
}
