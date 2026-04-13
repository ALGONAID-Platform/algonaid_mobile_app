import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/course_local_stroage.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remote;
  final CourseLocalDataSourse local;

  const CoursesRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    return _fetchData(
      fetchRemote: () => remote.fetchCourses(),
      fetchLocal: () => local.getAllCourses(),
      cacheData: (courses) => local.saveCourses(courses),
    );
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getMyCourses() async {
    return _fetchData(
      fetchRemote: () => remote.fetchMyCourses(),
      fetchLocal: () => local.getMyCourses(),
      cacheData: (courses) => local.saveMyCourses(courses),
    );
  }

  /// 🌟 الدالة المركزية لإدارة جلب البيانات (Logic Engine)
  Future<Either<Failure, List<CourseEntity>>> _fetchData({
    required Future<List<CourseEntity>> Function() fetchRemote,
    required List<CourseEntity> Function() fetchLocal,
    required Future<void> Function(List<CourseEntity>) cacheData,
  }) async {
    try {
      // 1. محاولة جلب البيانات من السيرفر (الخيار الأول دائماً لضمان التحديث)
      final remoteCourses = await fetchRemote();

      // 2. إذا نجح الاتصال، نقوم بتحديث الكاش فوراً (مسح القديم ووضع الجديد)
      await cacheData(remoteCourses);
      print("=====================================================");
      print(remoteCourses);
      print("=====================================================");
      return Right(remoteCourses);
    } catch (e) {
      // 3. في حالة الفشل (انقطاع نت، خطأ سيرفر، إلخ...) نلجأ للكاش
      try {
        final localCourses = fetchLocal();

        if (localCourses.isNotEmpty) {
          // ✅ تم العثور على بيانات قديمة، نعرضها للمستخدم بدلاً من رسالة الخطأ
          return Right(localCourses);
        }
      } catch (cacheError) {
        // إذا حدث خطأ حتى في قراءة الكاش، نتجاهله وننتقل لإرسال خطأ السيرفر الأساسي
      }

      // 4. إذا فشل السيرفر ولم نجد أي بيانات في الكاش (التطبيق يفتح لأول مرة مثلاً)
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }

      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
