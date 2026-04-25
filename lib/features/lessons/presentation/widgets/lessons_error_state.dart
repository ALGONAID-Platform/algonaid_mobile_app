import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:flutter/material.dart';

class LessonsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const LessonsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) =>
      AppErrorState(message: message, onRetry: onRetry);
}
