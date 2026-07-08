import 'dart:ui';

import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/heroWidget.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/timeout_image_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/constants/endpoints.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobile_app/core/utils/share_helper.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/course_reminder_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_snackbar.dart';

class CourseHeaderSliver extends StatelessWidget {
  final CourseEntity course;

  const CourseHeaderSliver({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasNoImage = Images.isInvalidImage(course.thumbnail);
    String resolvedUrl = course.thumbnail ?? "";
    if (!hasNoImage && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }
    final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);
    final bool isGuest = TokenStorage.getToken() == null;

    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: false,
      stretch: true,
      backgroundColor: context.surfaceContainer,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.2), // خلفية خفيفة جداً للزر
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go(isGuest ? Routes.guestHome : Routes.homePage);
                  }
                },
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: IconButton(
                  icon: const Icon(Icons.share_rounded, size: 22, color: Colors.white),
                  onPressed: () {
                    if (isGuest) {
                      AppSnackBar.show(
                        context: context,
                        message: 'عذراً، ميزة مشاركة الكورس غير متاحة في وضع الزائر. يرجى تسجيل الدخول للاستفادة منها! 🔒',
                        type: SnackBarType.warning,
                      );
                      return;
                    }
                    ShareHelper.shareCourse(course);
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: ValueListenableBuilder<Box<String>>(
                valueListenable: Hive.box<String>('course_reminders_box').listenable(),
                builder: (context, box, _) {
                  final hasReminder = box.containsKey(course.id.toString());
                  return Container(
                    color: Colors.black.withOpacity(0.2),
                    child: IconButton(
                      icon: Icon(
                        hasReminder
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_outlined,
                        color: hasReminder ? Colors.greenAccent : Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        if (isGuest) {
                          AppSnackBar.show(
                            context: context,
                            message: 'عذراً، ميزة تفعيل التنبيهات غير متاحة في وضع الزائر. يرجى تسجيل الدخول للاستفادة منها! 🔒',
                            type: SnackBarType.warning,
                          );
                          return;
                        }
                        AppBottomSheet.show(
                          context: context,
                          title: 'منبه الكورس الدراسي',
                          child: CourseReminderSheet(
                            courseId: course.id,
                            courseTitle: course.title,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: 48,
          bottom: 16,
          end: 16,
        ),
        centerTitle: false,
        title: AppHero(
          tag: "course_name${course.id}",
          child: Text(
            course.title,
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
              tag: "course_image${course.id}",
              child: (hasNoImage || isResolvedInvalid)
                  ? Image.asset(Images.noImageFound, fit: BoxFit.cover)
                  : TimeoutImageWrapper(
                      imageUrl: resolvedUrl,
                      fit: BoxFit.cover,
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
