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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      stretch: true,
      backgroundColor: context.surfaceContainer,
      iconTheme: IconThemeData(color: Colors.white),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.2), // خلفية خفيفة جداً للزر
              child: IconButton(
                icon: Directionality(
                  textDirection: TextDirection.ltr,
                  child: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 48,
          bottom: 16,
          end: 16,
        ),
        centerTitle: false,
        title: AppHero(
          tag: "course_name$courseId",
          child: Text(
            title,
            style: context.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.9),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // الصورة الأساسية
            AppHero(
              tag: "course_image$courseId",
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? "",
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset(Images.noImageFound, fit: BoxFit.cover),
              ),
            ),
            // تدرج لوني ذكي (Gradient Scrim)
            // في الوضع الفاتح نزيد التعتيم، وفي الداكن نتركه يندمج مع اللون الأصلي
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4), // تعتيم علوي للزر
                    Colors.transparent,
                    Colors.transparent,
                    isDark
                        ? context.surfaceContainer.withOpacity(
                            0.9,
                          ) // يندمج مع الثيم الداكن
                        : Colors.black.withOpacity(
                            0.7,
                          ), // تعتيم سفلي للنص في الوضع الفاتح
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
