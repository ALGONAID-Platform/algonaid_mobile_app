import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const ShimmerLoading.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  const ShimmerLoading.rounded({
    super.key,
    required this.width,
    required this.height,
    required BorderRadius borderRadius,
  }) : shapeBorder =  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)));

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.grey300,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
