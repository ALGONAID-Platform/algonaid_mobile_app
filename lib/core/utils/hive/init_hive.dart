import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
// import 'package:clean_architecture/core/constants/app_constants.dart';
// import 'package:clean_architecture/features/home/domain/entity/book_entity.dart';
// import 'package:clean_architecture/features/readingProgress/data/models/reading_progress_model.dart';
import 'package:hive/hive.dart';

Future<void> initHive() async {
   await Hive.openBox(AppConstants.boxAuthTokenName);
   await Hive.openBox(AppConstants.boxLessonsCache);
   await Hive.openBox(AppConstants.boxLessonDetailsCache);
   await Hive.openBox(AppConstants.boxLessonDownloads);
  // await Hive.openBox<BookEntity>(AppConstants.boxFeaturedNewsBox);
  // await Hive.openBox<BookEntity>(AppConstants.boxFeaturedTrendinBooks);
  // await Hive.openBox<BookEntity>(AppConstants.boxFeaturedTopRatedBooks);
  // await Hive.openBox<BookEntity>(AppConstants.boxFeaturedQuickReadBooks);
  // await Hive.openBox<ReadingProgressModel>(AppConstants.boxReadingProgress);
}
