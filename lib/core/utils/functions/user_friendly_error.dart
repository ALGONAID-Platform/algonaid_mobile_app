String toUserFriendlyErrorMessage(String? rawMessage) {
  final message = rawMessage?.trim();
  if (message == null || message.isEmpty) {
    return 'تعذر تحميل البيانات حالياً. حاول مرة أخرى.';
  }

  final normalized = message.toLowerCase();

  // Google Sign-in specific exceptions
  if (normalized.contains('sign_in_failed') ||
      normalized.contains('apiexception') ||
      normalized.contains('google_sign_in') ||
      normalized.contains('google')) {
    return 'فشل تسجيل الدخول باستخدام جوجل.\nتفاصيل الخطأ:nتنبيه: تأكد من تسجيل بصمة SHA-1 لجهازك (مفتاح الـ Debug) وحزمة التطبيق (com.example.algonaid_mobile_app) في مشروع Google Console أو Firebase المرتبط بالسيرفر.';
  }

  if (normalized.contains('internet') ||
      normalized.contains('network') ||
      normalized.contains('socket') ||
      normalized.contains('connection') ||
      message.contains('الإنترنت') ||
      message.contains('اتصال')) {
    return 'لا يوجد اتصال جيد بالإنترنت. تأكد من الشبكة ثم حاول مرة أخرى.';
  }

  if (normalized.contains('timeout') || message.contains('مهلة')) {
    return 'استغرق التحميل وقتاً أطول من المتوقع. حاول مرة أخرى.';
  }

  if (normalized.contains('unauthorized') ||
      normalized.contains('forbidden') ||
      normalized.contains('session expired') ||
      normalized.contains('token expired') ||
      normalized.contains('invalid token') ||
      message.contains('صلاحية الجلسة') ||
      message.contains('انتهت الجلسة')) {
    return 'انتهت صلاحية الجلسة أو لا يمكن إتمام الطلب حالياً. حاول تسجيل الدخول مرة أخرى.';
  }

  if (normalized.contains('not found') || message.contains('غير موجود')) {
    if (message.contains('الحساب') || message.contains('account')) {
      return 'هذا الحساب غير موجود. يرجى إنشاء حساب جديد أولاً.';
    }
    if (message.contains('البريد الإلكتروني') || message.contains('email')) {
      return 'البريد الإلكتروني الذي أدخلته غير مسجل لدينا. يرجى إنشاء حساب جديد.';
    }
    return 'المحتوى المطلوب غير متوفر حالياً.';
  }

  if (message.contains('بيانات الدخول غير صحيحة') || normalized.contains('invalid credentials')) {
    return 'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';
  }

  if (normalized.contains('exist') ||
      normalized.contains('already') ||
      normalized.contains('taken') ||
      normalized.contains('duplicate') ||
      normalized.contains('unique') ||
      message.contains('موجود مسبقاً') ||
      message.contains('مستخدم بالفعل') ||
      message.contains('مسجل')) {
    return 'هذا البريد الإلكتروني مسجل مسبقاً. يرجى محاولة تسجيل الدخول بدلاً من إنشاء حساب جديد، أو استخدام بريد إلكتروني آخر.';
  }

  if (normalized.contains('server') ||
      normalized.contains('api') ||
      normalized.contains('unknown error') ||
      message.contains('الخادم')) {
    return 'حدثت مشكلة أثناء تحميل البيانات. حاول مرة أخرى بعد قليل.';
  }

  return message;
}
