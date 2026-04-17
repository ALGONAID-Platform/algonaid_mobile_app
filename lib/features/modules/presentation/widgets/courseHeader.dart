import 'dart:ui';

import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseHeaderSliver extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onContinueTap;

  const CourseHeaderSliver({
    super.key,
    required this.title,
    this.onBackTap,
    this.onContinueTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0, // الارتفاع عند التمدد
      pinned: true, // ليبقى العنوان ثابتاً عند الانكماش
      stretch: true,
      backgroundColor: const Color(0xFF00897B),

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),

      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsetsDirectional.only(start: 48, bottom: 16),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl ?? "",
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Image.asset(Images.noImageFound, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7), // تعتيم أسفل النص
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
