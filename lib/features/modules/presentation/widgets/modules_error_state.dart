// algonaid_mobail_app/lib/features/modules/presentation/widgets/modules_error_state.dart

import 'package:flutter/material.dart';

class ModulesErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ModulesErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
        ],
      ),
    );
  }
}
