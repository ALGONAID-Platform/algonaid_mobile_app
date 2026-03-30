import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart'; // تأكد من المسار الصحيح
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';

class AppDialog {
  static void showDynamicDialog({
    BuildContext? context,
    required String title,
    required String message,
    bool isError = false,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) {
    final currentContext = context ?? navigatorKey.currentContext;
    if (currentContext == null) return;

    showDialog(
      context: currentContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط
              children: [
                // أيقونة علوية مميزة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isError
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isError
                        ? Icons.report_gmailerrorred_rounded
                        : Icons.check_circle_rounded,
                    color: isError ? Colors.red : Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // العنوان
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // الرسالة
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // الأزرار
                Row(
                  children: [
                    // زر الإلغاء
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          cancelText ?? "إغلاق",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                    if (onConfirm != null) ...[
                      const SizedBox(width: 12),
                      // زر التأكيد
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: isError
                                ? Colors.red
                                : AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            confirmText ?? "تأكيد",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
