// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';

import 'package:algonaid_mobail_app/core/theme/colors.dart';

// ignore: must_be_immutable
class DropDownButton extends StatelessWidget {
  DropDownButton({super.key, required this.auth});
  AuthServiceProvider auth;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<UserRole>(
        value: auth.selectedRole,
        borderRadius: BorderRadius.circular(5),
        items: [
          for (var role in UserRole.values)
            DropdownMenuItem(
              value: role,
              child: Text(
                role.code,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
        ],

        onChanged: (UserRole? newValue) {
          auth.setRole(newValue);
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(color: context.primary, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(color: context.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
