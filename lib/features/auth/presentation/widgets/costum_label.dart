import 'dart:ui';

import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

class CostumLabel extends StatelessWidget {
  const CostumLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "مرحبا بك في منصه الجنيد التعليميه",
        style: Styles.style18(context),
      ),
    );
  }
}
