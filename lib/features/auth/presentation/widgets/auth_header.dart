import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "مرحبا بك في منصه الجنيد التعليميه",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
