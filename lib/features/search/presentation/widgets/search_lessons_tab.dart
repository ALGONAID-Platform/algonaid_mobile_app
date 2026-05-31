import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/search/domain/entities/global_search_entity.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchLessonsTab extends StatelessWidget {
  final List<SearchLessonEntity> lessons;

  const SearchLessonsTab({
    super.key,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'لا توجد نتائج',
        subtitle: 'لا توجد دروس مطابقة',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: lessons.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.play_circle_fill, color: context.primary),
          ),
          title: Text(
            lesson.title,
            style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colorScheme.onSurface.withOpacity(0.5),
          ),
          onTap: () {
            context.push('${Routes.lessonDetails}/${lesson.id}');
          },
        );
      },
    );
  }
}
