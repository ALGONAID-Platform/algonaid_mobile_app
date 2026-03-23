import 'package:algonaid_mobail_app/core/widgets/loading/shimmer_loading.dart';
import 'package:flutter/material.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ShimmerLoading(
        width: double.infinity,
        height: 230,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
