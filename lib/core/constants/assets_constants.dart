//this class for svg images
class SVG {
  static const String googleSvg = "assets/svg/google-icon-logo-svgrepo-com.svg";

  static const String onboarding1 = "assets/svg/onboarding1.svg";
  static const String onboarding2 = "assets/svg/onboarding2.svg";
  static const String onboarding3 = "assets/svg/onboarding3.svg";
  static const String onboarding4 = "assets/svg/onboarding4.svg";
}

//this class for images
class Images {
  static const String onboarding1 = "assets/images/onboarding1.jpg";
  static const String noImageFound = "assets/images/noImageFound.jpg";
  static const String trophy = "assets/images/trophy.png";
  static const String logo = "assets/images/logo.png";
  static const String authLogo = "assets/images/auth_logo.png";
  //   static const String onboarding2 = "assets/images/onboarding2.jpg";
  //   static const String onboarding3 = "assets/images/onboarding3.jpg";

  static bool isInvalidImage(String? url) {
    if (url == null) return true;
    final String trimmed = url.trim();
    return trimmed.isEmpty ||
        trimmed == 'null' ||
        trimmed == 'undefined' ||
        trimmed == '/' ||
        trimmed == 'placeholder' ||
        trimmed.endsWith('/null') ||
        trimmed.endsWith('/undefined');
  }
}

class AppLottie {
  static const String goldMedal = "assets/lottie/gold_medal.json";
  static const String goldMedal2 = "assets/lottie/gold_medal2.json";
}
