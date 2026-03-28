import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/lessons/lesson_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsListPage extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
  });

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<_LessonListItem> _lessons = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLessons();
    });
  }

  Future<void> _loadLessons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = context.read<ApiService>();
      final data = await api.get(
        endpoint: 'http://localhost:3000/api/v1/modules/4',
      );

      final items = _extractList(data);
      final lessons = items
          .whereType<Map<String, dynamic>>()
          .map(_LessonListItem.fromJson)
          .toList();

      setState(() {
        _lessons = lessons;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _lessons = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data['lessons'] is List) {
        return data['lessons'] as List<dynamic>;
      }
      if (data['data'] is Map<String, dynamic>) {
        final nested = data['data'] as Map<String, dynamic>;
        if (nested['lessons'] is List) {
          return nested['lessons'] as List<dynamic>;
        }
      }
    }
    throw Exception('Unexpected lessons response format');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: Text(widget.moduleTitle),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_errorMessage != null) {
              return _ErrorState(
                message: _errorMessage!,
                onRetry: _loadLessons,
              );
            }

            if (_lessons.isEmpty) {
              return const Center(child: Text('لا توجد دروس حالياً'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _lessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return _LessonCard(
                  lesson: lesson,
                  displayOrder: lesson.order > 0 ? lesson.order : index + 1,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonDetailPage(lessonId: lesson.id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LessonListItem {
  final int id;
  final int moduleId;
  final String title;
  final String? description;
  final int order;
  final String? videoUrl;

  const _LessonListItem({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    this.description,
    this.videoUrl,
  });

  factory _LessonListItem.fromJson(Map<String, dynamic> json) {
    return _LessonListItem(
      id: json['id'] ?? 0,
      moduleId: json['moduleId'] ?? 0,
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      order: json['order'] ?? 0,
      videoUrl: json['videoUrl']?.toString(),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final _LessonListItem lesson;
  final int displayOrder;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.displayOrder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasVideo = lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayOrder.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.indigo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.description?.isNotEmpty == true
                        ? lesson.description!
                        : 'اضغط لعرض تفاصيل الدرس',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: hasVideo
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hasVideo ? 'فيديو' : 'نصي',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasVideo ? AppColors.primary : AppColors.grey400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
