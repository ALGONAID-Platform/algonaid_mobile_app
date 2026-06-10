import 'dart:ui';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/theme/styles.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';

class CustomWhiteAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userName;
  final String? userImageUrl;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onProfilePressed;
  final int notificationCount;
  final String? appBarTitle;
  final bool isGuest;

  const CustomWhiteAppBar({
    super.key,
    required this.userName,
    this.userImageUrl,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onSearchPressed,
    this.onProfilePressed,
    this.notificationCount = 0,
    this.appBarTitle,
    this.isGuest = false,
  });

  @override
  State<CustomWhiteAppBar> createState() => _CustomWhiteAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}

class _CustomWhiteAppBarState extends State<CustomWhiteAppBar>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _avatarPulseController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _avatarPulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _avatarPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 1.0,
      upperBound: 1.1,
    );
    _avatarPulseAnimation = _avatarPulseController;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _avatarPulseController.dispose();
    super.dispose();
  }

  void _onAvatarTap() async {
    await _avatarPulseController.forward();
    widget.onProfilePressed?.call();
    _avatarPulseController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: context.surface,
              border: Border(
                bottom: BorderSide(
                  color: context.theme.disabledColor.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                titleSpacing: 16,
                title: Row(
                  children: [
                    if (widget.isGuest) ...[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          if (screenWidth > 380) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<AuthServiceProvider>()
                                        .setAuthMode(true);
                                    context.push(Routes.auth);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: context.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AuthServiceProvider>()
                                        .setAuthMode(false);
                                    context.push(Routes.auth);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<AuthServiceProvider>().setAuthMode(
                                  true,
                                );
                                context.push(Routes.auth);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ] else if (widget.appBarTitle == null) ...[
                      GestureDetector(
                        onTap: _onAvatarTap,
                        child: Hero(
                          tag: 'user_profile_avatar',
                          child: ScaleTransition(
                            scale: _avatarPulseAnimation,
                            child: _buildUserAvatar(context.theme),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildGreetingText(context, context.onBackground),
                    ] else ...[
                      Text(
                        widget.appBarTitle!,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  _buildCircleIconButton(
                    icon: Icons.search_rounded,
                    onPressed: widget.onSearchPressed,
                    color: context.onBackground,
                  ),
                  if (!widget.isGuest) ...[
                    _buildAnimatedNotificationIcon(
                      context.theme,
                      context.onBackground,
                    ),
                  ],
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon, size: 24),
      color: color.withOpacity(0.8),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: color.withOpacity(0.05),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.primary.withOpacity(0.2), width: 2),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: context.primary.withOpacity(0.1),
        backgroundImage:
            (widget.userImageUrl != null && widget.userImageUrl!.isNotEmpty)
            ? NetworkImage(widget.userImageUrl!)
            : null,
        child: (widget.userImageUrl == null || widget.userImageUrl!.isEmpty)
            ? Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : '',
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.primary,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildGreetingText(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'مرحباً بك في منصة الجنيد',
          style: context.textTheme.bodySmall!.copyWith(),
        ),
        Text(widget.userName, style: context.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildAnimatedNotificationIcon(ThemeData theme, Color color) {
    final hasNotifications = widget.notificationCount > 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCircleIconButton(
          icon: Icons.notifications_none_rounded,
          onPressed: widget.onNotificationPressed,
          color: color,
        ),
        if (hasNotifications)
          Positioned(
            right: 8,
            top: 8,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                child: Center(
                  child: Text(
                    widget.notificationCount > 9
                        ? "+9"
                        : widget.notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
