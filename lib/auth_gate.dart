import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/core/utils/functions/check_user_auth_token.dart';
import 'package:algonaid/core/constants/assets_constants.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Smoothly scale up from 1.0 (native size) to 1.3
    // Uses Curves.easeOutCubic to start fast and then decelerate/slow down
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _init();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // Start session restore asynchronously in the background
    final restoreFuture = context.read<AuthServiceProvider>().restoreSession();

    // Start the zoom animation
    _animationController.forward();

    // Wait for the animation duration to ensure smooth transition and typing effect finishes
    await Future.delayed(const Duration(milliseconds: 2000));

    // Await the restoreSession task to complete
    await restoreFuture;

    if (mounted) {
      await checkUserAuth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    // Background color matches the native splash background exactly to prevent any flashes
    final backgroundColor = isDark ? AppColors.bgDark : AppColors.bgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Premium Subtle Geometric Background
          Positioned.fill(
            child: CustomPaint(
              painter: SplashBackgroundPainter(
                isDark: isDark,
                primaryColor: AppColors.primary,
              ),
            ),
          ),
          
          // Centered Animated Logo and Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'app_logo_hero',
                    child: Image.asset(
                      Images.logo,
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Spacing for scale effect
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ).copyWith(
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'منصة الجنيد',
                          speed: const Duration(milliseconds: 100),
                          cursor: '|',
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw premium, lightweight geometric patterns in the background
class SplashBackgroundPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;

  SplashBackgroundPainter({required this.isDark, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric decorative rings around the logo
    final ringPaint = Paint()
      ..color = primaryColor.withOpacity(isDark ? 0.03 : 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, size.width * 0.28, ringPaint);
    canvas.drawCircle(center, size.width * 0.45, ringPaint);
    canvas.drawCircle(center, size.width * 0.62, ringPaint);

    // Draw subtle abstract curves in the top-left and bottom-right corners
    final cornerPaint = Paint()
      ..color = primaryColor.withOpacity(isDark ? 0.02 : 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Top-left design
    final topLeftPath1 = Path()
      ..moveTo(0, size.height * 0.12)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.08, size.width * 0.12, 0);
    canvas.drawPath(topLeftPath1, cornerPaint);

    final topLeftPath2 = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.12, size.height * 0.12, size.width * 0.18, 0);
    canvas.drawPath(topLeftPath2, cornerPaint);

    // Bottom-right design
    final bottomRightPath1 = Path()
      ..moveTo(size.width, size.height * 0.88)
      ..quadraticBezierTo(size.width * 0.92, size.height * 0.92, size.width * 0.88, size.height);
    canvas.drawPath(bottomRightPath1, cornerPaint);

    final bottomRightPath2 = Path()
      ..moveTo(size.width, size.height * 0.82)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.88, size.width * 0.82, size.height);
    canvas.drawPath(bottomRightPath2, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
