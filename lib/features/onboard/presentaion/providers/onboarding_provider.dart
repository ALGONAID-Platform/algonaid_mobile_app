import 'package:algonaid_mobail_app/features/onboard/data/models/onboarding_data.dart';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  int _current_bage = 0;
  final PageController _pageController = PageController();

  // ignore: non_constant_identifier_names
  int get current_bage => _current_bage;
  PageController get pageController => _pageController;

  void onPagechange(int index) {
    _current_bage = index;
    notifyListeners();
  }

  void goToNextPage() {
    if (current_bage < OnboardingData.items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
