// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';

import 'package:algonaid_mobail_app/core/theme/colors.dart';

// ignore: must_be_immutable
class DropDownButton extends StatelessWidget {
  DropDownButton({super.key, required this.auth});
  AuthStateProvider auth;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<UserRole>(
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
          print(newValue);
          auth.setRole(newValue);
        },
        decoration: InputDecoration(
          labelText: "نوع المستخدم",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(color: AppColors.primary, width: 3),
          ),
        ),
      ),
    );
  }
}
