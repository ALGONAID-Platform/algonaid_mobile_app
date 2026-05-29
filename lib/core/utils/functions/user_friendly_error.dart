String toUserFriendlyErrorMessage(String? rawMessage) {
  final message = rawMessage?.trim();
  if (message == null || message.isEmpty) {
    return 'تعذر تحميل البيانات حالياً. حاول مرة أخرى.';
  }

  final normalized = message.toLowerCase();

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
      normalized.contains('token') ||
      message.contains('صلاحية') ||
      message.contains('تسجيل الدخول')) {
    return 'انتهت صلاحية الجلسة أو لا يمكن إتمام الطلب حالياً. حاول تسجيل الدخول مرة أخرى.';
  }

  if (normalized.contains('not found') || message.contains('غير موجود')) {
    return 'المحتوى المطلوب غير متوفر حالياً.';
  }

  if (normalized.contains('server') ||
      normalized.contains('api') ||
      normalized.contains('unknown error') ||
      message.contains('الخادم')) {
    return 'حدثت مشكلة أثناء تحميل البيانات. حاول مرة أخرى بعد قليل.';
  }

  return message;
}
