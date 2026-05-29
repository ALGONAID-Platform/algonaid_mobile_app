import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("لا توجد كورسات"));
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) =>
      AppErrorState(message: message, onRetry: onRetry);
}
