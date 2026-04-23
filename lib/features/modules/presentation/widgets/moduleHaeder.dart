import 'dart:ui';

import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/heroWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseHeaderSliver extends StatelessWidget {
  final String title;
  final int courseId;
  final String? imageUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onContinueTap;

  const CourseHeaderSliver({
    super.key,
    required this.title,
    this.onBackTap,
    this.onContinueTap,
    this.imageUrl,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0, // الارتفاع عند التمدد
      pinned: true, // ليبقى العنوان ثابتاً عند الانكماش
      stretch: true,
      backgroundColor: context.primary,

      leading: IconButton(
        icon: Directionality(
          textDirection: TextDirection.ltr,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),

      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 48, bottom: 16),
        title: AppHero(
          tag: "course_name${courseId}",
          child: Text(
            title,
            style: context.titleLarge!.copyWith(color: AppColors.white),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppHero(
              tag: "course_image${courseId}",

              child: CachedNetworkImage(
                imageUrl: imageUrl ?? "",
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset(Images.noImageFound, fit: BoxFit.cover),
              ),
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
