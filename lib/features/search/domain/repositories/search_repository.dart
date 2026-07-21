import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/search/domain/entities/global_search_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepository {
  Future<Either<Failure, GlobalSearchEntity>> searchCourses(String query);
}
