import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/buildCourseCard.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/widgets/course_view_variants.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/shared_app_bar.dart';

enum CourseViewType { largeList, thinList, grid }

class CoursesViewAllPage extends StatefulWidget {
  final String title;
  final List<CourseEntity> courses;

  const CoursesViewAllPage({
    super.key,
    required this.title,
    required this.courses,
  });

  @override
  State<CoursesViewAllPage> createState() => _CoursesViewAllPageState();
}

class _CoursesViewAllPageState extends State<CoursesViewAllPage> {
  CourseViewType _currentViewType = CourseViewType.largeList;

  void _toggleViewType() {
    setState(() {
      if (_currentViewType == CourseViewType.largeList) {
        _currentViewType = CourseViewType.thinList;
      } else if (_currentViewType == CourseViewType.thinList) {
        _currentViewType = CourseViewType.grid;
      } else {
        _currentViewType = CourseViewType.largeList;
      }
    });
  }

  IconData _getViewIcon() {
    switch (_currentViewType) {
      case CourseViewType.largeList:
        return Icons.view_agenda_outlined;
      case CourseViewType.thinList:
        return Icons.format_list_bulleted;
      case CourseViewType.grid:
        return Icons.grid_view;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: SharedAppBar(
          title: widget.title,
          actions: [
            IconButton(
              icon: Icon(_getViewIcon(), color: context.primary),
              onPressed: _toggleViewType,
              tooltip: 'تغيير شكل العرض',
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.courses.isEmpty) {
      return Center(
        child: Text(
          'لا توجد دورات لعرضها',
          style: context.textTheme.titleMedium,
        ),
      );
    }

    if (_currentViewType == CourseViewType.grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: widget.courses.length,
        itemBuilder: (context, index) {
          return CourseGridItem(course: widget.courses[index]);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.courses.length,
      itemBuilder: (context, index) {
        if (_currentViewType == CourseViewType.thinList) {
          return CourseThinCard(course: widget.courses[index]);
        } else {
          return SizedBox(
            height: 345,
            child: CourseCard(course: widget.courses[index]),
          );
        }
      },
    );
  }
}
