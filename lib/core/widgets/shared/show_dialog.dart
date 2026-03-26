import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static void showDynamicDialog({
     BuildContext? context,
    required String title,
    required String message,
    bool isError = false,
    VoidCallback? onConfirm,
  }) {
    final currentContext = context ?? navigatorKey.currentContext;
    
    if (currentContext == null) return;
    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            ),
            if (onConfirm != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isError ? Colors.red : Colors.blue,
                ),
                child: const Text("تأكيد"),
              ),
          ],
        );
      },
    );
  }
}