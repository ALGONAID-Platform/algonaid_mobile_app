// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';


class AnimatedSwitcherCostum extends StatelessWidget {
    final AuthServiceProvider auth;
    final Widget child ;
  AnimatedSwitcherCostum({
    Key? key,
    required this.auth,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:!auth.isLogin ?child :SizedBox.shrink() ,

    );
  }
}
