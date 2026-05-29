import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(Images.logo, height: 120, width: 120));
  }
}
