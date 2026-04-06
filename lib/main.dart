import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/appRouters.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/hive/hive_setup.dart';
import 'package:algonaid_mobail_app/core/utils/hive/init_hive.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/utils/providers/app_providers.dart';
import 'package:algonaid_mobail_app/features/onboard/presentaion/pages/onboarding_screen.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/pages/signin_&_signup_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Ensures that widget binding is initialized before any asynchronous operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter to support local data storage
  await Hive.initFlutter();

  // Custom initialization logic for Hive (e.g., registering adapters)
  await initHive();

  // Initialize the TokenStorage box to manage user authentication tokens
  await TokenStorage.init();

  // Initialize SharedPreferences or custom caching helper for general app data
  await CacheHelper.init();

  // Initialize the Hive service instance for database operations
  HiveService();

  // Set up the Service Locator (GetIt) to handle Dependency Injection across the app
  setupServiceLocator();

  // Launch the root widget of the application wrapped with global providers
  runApp(AppProviders(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Change notification Status Bar Color to green
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryLight,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeApp.lightTheme,
      darkTheme: ThemeApp.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouters.routers,


      // home: OnboardingScreen(),
    );
  }
}







// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {

//     return OnboardingScreen();
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(const MaterialApp(home: AdvancedColorAnimation()));

// class AdvancedColorAnimation extends StatefulWidget {
//   const AdvancedColorAnimation({super.key});

//   @override
//   State<AdvancedColorAnimation> createState() => _AdvancedColorAnimationState();
// }

// class _AdvancedColorAnimationState extends State<AdvancedColorAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _blueController;
//   late AnimationController _redController;
//   late Animation<AlignmentGeometry> _redAnimation;
//   late Animation<AlignmentGeometry> _blueAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // تعريف الكنترولر
//     _redController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//       reverseDuration: const Duration(seconds: 3),
//     );
//     _blueController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//       reverseDuration: const Duration(seconds: 3),
//     );

//     // حركة الكرة الحمراء (من فوق لتحت)
//     _redAnimation =
//         Tween<AlignmentGeometry>(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ).animate(
//           CurvedAnimation(
//             parent: _redController,
//             curve: Curves.bounceInOut,
//             reverseCurve: Curves.easeInOutCubicEmphasized,
//           ),
//         );

//     // حركة الكرة الزرقاء (من اليسار لليمين)
//     _blueAnimation =
//         Tween<AlignmentGeometry>(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ).animate(
//           CurvedAnimation(
//             parent: _blueController,
//             curve: Curves.linearToEaseOut,
//             reverseCurve: Curves.bounceOut,
//           ),
//         );

//     _redController.addListener(() {
//       if (_redController.value >= 0.5 && _blueController.value == 0) {
//         _blueController.forward();
//       }
//       if (_redController.value <= 0.5 && _blueController.value == 1.0) {
//         _blueController.reverse();
//       }
//     });
//     // _blueController.addStatusListener((status) {
//     //   if (_blueController.status == AnimationStatus.completed &&
//     //       _redController.status == AnimationStatus.dismissed) {
//     //     _redController.forward();
//     //   }
//     //   if (_redController.status == AnimationStatus.completed &&
//     //       _blueController.status == AnimationStatus.dismissed) {
//     //     _redController.reverse();
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     _blueController.dispose();
//     _redController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("منصة الجنيد - أنيميشن")),
//       body: Column(
//         children: [
//           const SizedBox(height: 30),
//           // نمرر حركات الأنميشن للويدجت المسؤول عن الرسم
//           Expanded(
//             child: AnimatedCircle(
//               redAnim: _redAnimation,
//               blueAnim: _blueAnimation,
//             ),
//           ),
//           // نمرر الكنترولر لويدجت التحكم
//           Controlls(
//             redController: _redController,
//             blueController: _blueController,
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedCircle extends StatelessWidget {
//   final Animation<AlignmentGeometry> redAnim;
//   final Animation<AlignmentGeometry> blueAnim;

//   const AnimatedCircle({
//     super.key,
//     required this.redAnim,
//     required this.blueAnim,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // الكرة الحمراء تتحرك عمودياً
//         AlignTransition(
//           alignment: redAnim,
//           child: const CircleAvatar(backgroundColor: Colors.red, radius: 30),
//         ),
//         // الكرة الزرقاء تتحرك أفقياً
//         AlignTransition(
//           alignment: blueAnim,
//           child: const CircleAvatar(backgroundColor: Colors.blue, radius: 30),
//         ),
//       ],
//     );
//   }
// }

// class Controlls extends StatelessWidget {
//   final AnimationController redController;
//   final AnimationController blueController;
//   const Controlls({
//     super.key,
//     required this.redController,
//     required this.blueController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       alignment: WrapAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () => redController.forward(),
//           child: const Text("Forward"),
//         ),
//         ElevatedButton(
//           onPressed: () => redController.reverse(),
//           child: const Text("Reverse"),
//         ),
//         ElevatedButton(
//           onPressed: () => blueController.stop(),
//           child: const Text("Stop"),
//         ),
//         ElevatedButton(
//           onPressed: () => blueController.reset(),
//           child: const Text("Reset"),
//         ),
//         ElevatedButton(
//           onPressed: () => blueController.repeat(reverse: true),
//           child: const Text("Repeat"),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(const MaterialApp(home: AdvancedColorAnimation()));

// class AdvancedColorAnimation extends StatefulWidget {
//   const AdvancedColorAnimation({super.key});

//   @override
//   State<AdvancedColorAnimation> createState() => _AdvancedColorAnimationState();
// }

// class _AdvancedColorAnimationState extends State<AdvancedColorAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _colorController;

//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // تعريف الكنترولر
//     _colorController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//       reverseDuration: const Duration(seconds: 3),
//     );

//     // حركة الكرة الزرقاء (من اليسار لليمين)
//     _colorAnimation = ColorTween(
//       begin: Colors.red,
//       end: Colors.green,
//     ).animate(_colorController);
//   }

//   @override
//   void dispose() {
//     _colorController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("منصة الجنيد - أنيميشن")),
//       body: Column(
//         children: [
//           const SizedBox(height: 30),
//           // نمرر حركات الأنميشن للويدجت المسؤول عن الرسم
//           AnimatedCircle(colorAnimated: _colorAnimation),
//           Spacer(),
//           // نمرر الكنترولر لويدجت التحكم
//           Controlls(colorController: _colorController),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedCircle extends StatelessWidget {
//   final Animation<Color?> colorAnimated;

//   const AnimatedCircle({super.key, required this.colorAnimated});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: colorAnimated,
//       builder: (context, child) {
//         return Container(width: 100, height: 100, color: colorAnimated.value);
//       },
//     );
//   }
// }

// class Controlls extends StatelessWidget {
//   final AnimationController colorController;
//   const Controlls({super.key, required this.colorController});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       alignment: WrapAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () => colorController.forward(),
//           child: const Text("Forward"),
//         ),
//         ElevatedButton(
//           onPressed: () => colorController.reverse(),
//           child: const Text("Reverse"),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(home: FunnyHairAnimation()));

// class AdvancedColorAnimation extends StatefulWidget {
//   const AdvancedColorAnimation({super.key});

//   @override
//   State<AdvancedColorAnimation> createState() => _AdvancedColorAnimationState();
// }

// class _AdvancedColorAnimationState extends State<AdvancedColorAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _colorController;

//   late Animation<Color?> _colorAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // تعريف الكنترولر
//     _colorController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//       reverseDuration: const Duration(seconds: 3),
//     );

//     // حركة الكرة الزرقاء (من اليسار لليمين)
//     _colorAnimation = ColorTween(
//       begin: Colors.red,
//       end: Colors.green,
//     ).animate(_colorController);
//   }

//   @override
//   void dispose() {
//     _colorController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("منصة الجنيد - أنيميشن")),
//       body: Column(
//         children: [
//           const SizedBox(height: 30),
//           // نمرر حركات الأنميشن للويدجت المسؤول عن الرسم
//           AnimatedCircle(colorAnimated: _colorAnimation),
//           Spacer(),
//           // نمرر الكنترولر لويدجت التحكم
//           Controlls(colorController: _colorController),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedCircle extends StatelessWidget {
//   final Animation<Color?> colorAnimated;

//   const AnimatedCircle({super.key, required this.colorAnimated});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: colorAnimated,
//       builder: (context, child) {
//         return Container(width: 100, height: 100, color: colorAnimated.value);
//       },
//     );
//   }
// }

// class Controlls extends StatelessWidget {
//   final AnimationController colorController;
//   const Controlls({super.key, required this.colorController});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       alignment: WrapAlignment.center,
//       children: [
//         ElevatedButton(
//           onPressed: () => colorController.forward(),
//           child: const Text("Forward"),
//         ),
//         ElevatedButton(
//           onPressed: () => colorController.reverse(),
//           child: const Text("Reverse"),
//         ),
//       ],
//     );
//   }
// }
// class FunnyHairAnimation extends StatefulWidget {
//   @override
//   State<FunnyHairAnimation> createState() => _FunnyHairAnimationState();
// }

// class _FunnyHairAnimationState extends State<FunnyHairAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _mainController; // كنترولر واحد للكل أفضل وأخف
//   late Animation<double> turnsAnimation;
//   late Animation<Color?> colorAnimation;
//   late Animation<double> scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _mainController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     );

//     // ربط الدوران بالكنترولر
//     turnsAnimation = Tween<double>(begin: 0, end: 0.1).animate(_mainController);

//     // ربط اللون (استخدام ColorTween هو السر)
//     colorAnimation = ColorTween(
//       begin: Colors.red,
//       end: Colors.blue,
//     ).animate(_mainController);

//     // ربط الحجم
//     scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.5,
//     ).animate(_mainController);
//   }

//   bool isOrignal = true;

//   void _animateHair() {
//     isOrignal = !isOrignal;
//     setState(() {

//     });
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Expanded(
//               child: Stack(
//                 children: [
//                   AnimatedSlide(
//                     offset: isOrignal ? Offset(0, 0) : Offset(0.5, 1),
//                     duration: Duration(seconds: 1),
//                     child: Container(height: 50, width: 100, color: Colors.red),
//                   ),
//                   Container(height: 50, width: 100, color: Colors.green),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 50),
//           ElevatedButton(
//             onPressed: _animateHair,
//             child: const Text("هز الشعر وتغيير اللون!"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FunnyHairAnimation extends StatefulWidget {
//   @override
//   State<FunnyHairAnimation> createState() => _FunnyHairAnimationState();
// }

// class _FunnyHairAnimationState extends State<FunnyHairAnimation> with TickerProviderStateMixin{

//   @override
//   void initState() {

//     super.initState();
//   }

//   bool flag = false;

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Stack(
//               children: [

//               ],
//             ),
//           ),
//           const SizedBox(height: 50),
//           ElevatedButton(
//             onPressed: () {
//               flag = !flag;
//               setState(() {});
//             },
//             child: const Text("هز الشعر وتغيير اللون!"),
//           ),
//         ],
//       ),
//     );
//   }
// }
