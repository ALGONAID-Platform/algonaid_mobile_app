import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/search/domain/entities/global_search_entity.dart';
import 'package:algonaid_mobail_app/features/search/domain/repositories/search_repository.dart';
import 'package:dartz/dartz.dart';

class SearchCoursesUseCase {
  final SearchRepository repository;

  const SearchCoursesUseCase(this.repository);

  Future<Either<Failure, GlobalSearchEntity>> call(String query) async {
    return await repository.searchCourses(query);
  }
}
