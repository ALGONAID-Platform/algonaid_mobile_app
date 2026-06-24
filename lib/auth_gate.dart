import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobile_app/core/utils/functions/check_user_auth_token.dart';
import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    // Smoothly scale up from 1.0 (native size) to 2.2
    // Uses Curves.easeOutCubic to start fast and then decelerate/slow down
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.2).animate(
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

    // Wait for the animation duration (800ms) to ensure smooth transition
    await Future.delayed(const Duration(milliseconds: 800));

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
          
          // Centered Animated Logo
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Hero(
                tag: 'app_logo_hero',
                child: Image.asset(
                  Images.logo,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
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
