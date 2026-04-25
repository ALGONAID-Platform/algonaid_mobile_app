import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/utils/functions/user_friendly_error.dart';
import 'package:flutter/material.dart';

class AppErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  final String buttonText;

  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.buttonText = 'تحميل مرة أخرى',
  });

  @override
  Widget build(BuildContext context) {
    final friendlyMessage = toUserFriendlyErrorMessage(message);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.red,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              friendlyMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
