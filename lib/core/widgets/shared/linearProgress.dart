import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:flutter/material.dart';

class LinearProgress extends StatelessWidget {
  final double? minHieght;
  final double? hPadding;
  final double progressPercentage;
  const LinearProgress({
    super.key,
    this.minHieght = 6,
    required this.progressPercentage,
    this.hPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding ?? 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: LinearProgressIndicator(
            value: progressPercentage / 100,
            minHeight: minHieght,
            backgroundColor: context.onBackground.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(context.primary),
          ),
        ),
      ),
    );
  }
}
