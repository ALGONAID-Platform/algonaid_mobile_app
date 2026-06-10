import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class GuestAccessPrompt {
  static void show(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onLogin,
    VoidCallback? onGuest,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final theme = Theme.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final verticalInset = (screenHeight * 0.34).clamp(120.0, 260.0).toDouble();

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(24, verticalInset, 24, verticalInset),
        elevation: 0,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        duration: const Duration(seconds: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: context.primary.withOpacity(0.12),
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_person_rounded,
                      color: context.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title ?? 'الوصول محدود للضيوف',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message ??
                    'يمكنك تسجيل الدخول للوصول الكامل، أو المتابعة كضيف لعرض النسخة المحدودة.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.78),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        if (onGuest != null) {
                          onGuest();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: context.primary.withOpacity(0.18),
                        ),
                        foregroundColor: context.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'المتابعة كضيف',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        if (onLogin != null) {
                          onLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: context.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showGuestLoginDialog(
  BuildContext context, {
  String? title,
  String? message,
  VoidCallback? onLogin,
  VoidCallback? onGuest,
}) {
  GuestAccessPrompt.show(
    context,
    title: title,
    message: message,
    onLogin: onLogin,
    onGuest: onGuest,
  );
}
