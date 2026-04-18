// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String text;
  final double Vpadding;
  TextLabel({Key? key, required this.text, this.Vpadding = 0.0});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Vpadding),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          // نستخدم colorScheme لضمان تغير اللون مع الثيم
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
