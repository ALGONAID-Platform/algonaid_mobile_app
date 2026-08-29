import 'package:algonaid/features/lessons/domain/entities/lesson.dart';

class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      page: int.tryParse(json['page']?.toString() ?? '') ?? 1,
      limit: int.tryParse(json['limit']?.toString() ?? '') ?? 10,
      totalPages: int.tryParse(json['totalPages']?.toString() ?? '') ?? 1,
    );
  }
}

class PaginatedLessons {
  final List<Lesson> lessons;
  final PaginationMeta meta;

  PaginatedLessons({
    required this.lessons,
    required this.meta,
  });
}
