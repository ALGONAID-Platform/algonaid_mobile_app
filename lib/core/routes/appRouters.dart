// import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
// import 'package:clean_architecture/core/routes/authGuard.dart';
// import 'package:clean_architecture/core/routes/navigatorKey.dart';
// import 'package:clean_architecture/core/routes/paths_routes.dart';
// import 'package:clean_architecture/features/auth/presentaion/views/forget_password.dart';
// import 'package:clean_architecture/features/auth/presentaion/views/login.dart';
// import 'package:clean_architecture/features/auth/presentaion/views/sign_up.dart';
// import 'package:clean_architecture/features/home/domain/entity/book_entity.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/screens/details_page.dart';
// import 'package:clean_architecture/features/home/presentaion/presentaion/screens/home_page.dart';
// import 'package:clean_architecture/features/pdfViewer/precentation/pdf_viewer_page.dart';
// import 'package:clean_architecture/features/search/precentation/search_page.dart';
// import 'package:clean_architecture/features/splash/presentaion/views/spalsh_view.dart';
// import 'package:go_router/go_router.dart';

// /*
// بدون navigatorKey: لا يمكنك تغيير الشاشة إلا من داخل ملفات الـ UI (StatelessWidget / StatefulWidget).

// مع navigatorKey: يمكنك تغيير الشاشة من أي مكان (Dio, Bloc, Services, Background Tasks) */
// abstract class AppRouters {
//   static final routers = GoRouter(
//     navigatorKey: navigatorKey,
//     redirect:
//         (context, state) => RouterAuthGuard.handleRedirect(context, state),

//     routes: [
//       GoRoute(path: '/', builder: (context, state) => const SplashView()),
//       GoRoute(
//         path: Routes.loginPage,
//         builder: (context, state) => const LoginView(),
//       ),
//       GoRoute(
//         path: Routes.signUp,
//         builder: (context, state) => const SignUpView(),
//       ),
//       GoRoute(
//         path: Routes.forgetPassword,
//         builder: (context, state) => const ForgotPasswordView(),
//       ),
//       GoRoute(
//         path: Routes.homePage,
//         builder: (context, state) =>  HomePage(),
//       ),
//       GoRoute(
//         path: Routes.searchBooks,
//         builder: (context, state) =>  SearchPage(),
//       ),
//       GoRoute(
//         path: Routes.detailsPage,
//         builder: (context, state) {
//           BookEntity data = state.extra as BookEntity;
//           return DetailsPage(book: data);
//         },
//       ),
//       GoRoute(
//         path: Routes.pdfViewerPage,
//         builder: (context, state) {
//           final args = state.extra as Map<String, dynamic>;
//           return PdfViewerPage(
//             filePath: args['filePath'],
//             bookId: args['bookId'],
//             userId: args['userId'],
//             currentPage: args['currentPage'] ?? 0,
//             book: args['book'],
//           );
//         },
//       ),
//     ],
//   );
// }
