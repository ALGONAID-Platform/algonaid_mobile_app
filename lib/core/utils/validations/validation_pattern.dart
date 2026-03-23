abstract class ValidationPatterns {
  // Email
  static final email = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    caseSensitive: false,
  );
  
  // Saudi phone numbers
  static final saudiPhone = RegExp(
    r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$',
  );
  
  // Strong password (8+ chars, 1 uppercase, 1 lowercase, 1 number, 1 special)
  static final strongPassword = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  
  // Medium password (6+ chars, letters and numbers)
  static final mediumPassword = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  
  // Weak password (just length check)
  static final weakPassword = RegExp(r'^.{6,}$');
  
  // English name
  static final englishName = RegExp(r'^[a-zA-Z\s]{2,50}$');

  // Arabic name
  static final arabicName = RegExp(r'^[\u0600-\u06FF\s\.]{2,50}$');
  
  // Numbers only (Useful for OTP)
  static final numbersOnly = RegExp(r'^\d+$');
}
