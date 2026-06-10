import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobile_app/core/utils/functions/check_user_auth_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _init();
    });
  }

  Future<void> _init() async {
    await context.read<AuthServiceProvider>().restoreSession();
    await checkUserAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
