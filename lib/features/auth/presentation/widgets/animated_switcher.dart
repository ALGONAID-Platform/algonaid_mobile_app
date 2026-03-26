// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_state_provider.dart';

class AnimatedSwitcherCostum extends StatelessWidget {
    AuthStateProvider auth;
    Widget child ;
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
