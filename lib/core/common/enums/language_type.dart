enum LanguageType { arabic, english }

extension LanguageTypeExtension on LanguageType {
  String get code {
    switch (this) {
      case LanguageType.arabic:
        return 'ar';
      case LanguageType.english:
        return 'en';
    }
  }
}
