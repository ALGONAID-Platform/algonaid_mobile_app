// lib/core/providers/app_providers.dart

import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
      final getIt = GetIt.instance; //Service Locator

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStateProvider()),
        ChangeNotifierProvider(create: (_) => getIt<AuthServiceProvider>()),

      ],
      child: child,
    );
  }
}