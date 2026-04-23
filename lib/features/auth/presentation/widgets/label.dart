// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  String text;
  double Vpadding;
  TextLabel({Key? key, required this.text, this.Vpadding = 0.0});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Vpadding),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          // نستخدم colorScheme لضمان تغير اللون مع الثيم
          color: context.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
