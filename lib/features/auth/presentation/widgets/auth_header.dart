import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(Images.authLogo, height: 120, width: 120));
  }
}
