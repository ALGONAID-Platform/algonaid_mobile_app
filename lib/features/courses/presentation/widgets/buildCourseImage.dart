import 'package:algonaid/core/constants/endpoints.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:algonaid/core/widgets/shared/heroWidget.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/core/widgets/shared/timeout_image_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BuildCourseImage extends StatelessWidget {
  final CourseEntity course;
  final String heroTagSuffix;

  const BuildCourseImage({super.key, required this.course, this.heroTagSuffix = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final bool hasNoImage = Images.isInvalidImage(course.thumbnail);
    String resolvedUrl = course.thumbnail;
    if (!hasNoImage && !resolvedUrl.startsWith('http')) {
      resolvedUrl = resolvedUrl.startsWith('/')
          ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
          : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
    }

    final bool isResolvedInvalid = Images.isInvalidImage(resolvedUrl);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: (hasNoImage || isResolvedInvalid)
                      ? Image.asset(Images.noImageFound, fit: BoxFit.contain)
                      : TimeoutImageWrapper(
                          imageUrl: resolvedUrl,
                          fit: BoxFit.contain,
                        ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            child: AppHero(
              tag: "course_image${course.id}$heroTagSuffix",
              child: (hasNoImage || isResolvedInvalid)
                  ? Image.asset(
                      Images.noImageFound,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : TimeoutImageWrapper(
                      imageUrl: resolvedUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: IgnorePointer(
              child: AppHero(
                tag: "course_name${course.id}$heroTagSuffix",
                child: Text(
                  course.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          ValueListenableBuilder<Box<String>>(
            valueListenable: Hive.box<String>('course_reminders_box').listenable(),
            builder: (context, box, _) {
              final hasReminder = box.containsKey(course.id.toString());
              if (!hasReminder) return const SizedBox.shrink();
              return Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.greenAccent.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.alarm_on_rounded,
                    color: Colors.greenAccent,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
