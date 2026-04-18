import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart'; // New Import
import 'package:algonaid_mobail_app/core/constants/app_constants.dart'; // New Import
import 'package:algonaid_mobail_app/features/onboard/data/models/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingProvider extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  int _current_bage = 0;

  bool _isConvertingToCircle = false;

  final PageController _pageController = PageController();

  // ignore: non_constant_identifier_names
  int get current_bage => _current_bage;
  bool get isConvertingToCircle => _isConvertingToCircle;
  PageController get pageController => _pageController;

  void onPagechange(int index) {
    _current_bage = index;
    notifyListeners();
  }

  void goToNextPage() async {
    if (current_bage < OnboardingData.items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _isConvertingToCircle = true;
      notifyListeners();

      // Save onboarding completion status
      await CacheHelper.saveData(key: AppConstants.onBoarding, value: true);

      final context = navigatorKey.currentContext;
      await Future.delayed(const Duration(milliseconds: 200));

      // Navigate to home page (CoursesListPage)
      GoRouter.of(context!).go(Routes.homePage);
    }
    notifyListeners();
  }

  void goToPrevousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }
}
