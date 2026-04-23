import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class CustomWhiteAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userName;
  final String? userImageUrl;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onProfilePressed;
  final int notificationCount;

  const CustomWhiteAppBar({
    super.key,
    required this.userName,
    this.userImageUrl,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onSearchPressed,
    this.onProfilePressed,
    this.notificationCount = 0,
  });

  @override
  State<CustomWhiteAppBar> createState() => _CustomWhiteAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8); // Slightly bigger for glass effect
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

    // نبض لبادج الإشعارات
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.17).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic),
    );

    // نبض لصورة المستخدم عند الضغط
    _avatarPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 1.0,
      upperBound: 1.12,
    );
    _avatarPulseAnimation = CurvedAnimation(
      parent: _avatarPulseController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _avatarPulseController.dispose();
    super.dispose();
  }

  void _onAvatarTap() async {
    if (widget.onProfilePressed != null) {
      await _avatarPulseController.forward();
      widget.onProfilePressed?.call();
      _avatarPulseController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dynamicTextColor = theme.colorScheme.onSurface;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.85),
          backgroundBlendMode: BlendMode.luminosity,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  color: dynamicTextColor.withOpacity(0.86),
                  splashRadius: 22,
                  onPressed: widget.onMenuPressed,
                  tooltip: 'القائمة',
                  style: IconButton.styleFrom(
                    backgroundColor: dynamicTextColor.withOpacity(0.03),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _onAvatarTap,
                  child: Hero(
                    tag: 'user_profile_avatar',
                    child: ScaleTransition(
                      scale: _avatarPulseAnimation,
                      child: _buildUserAvatar(theme),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                _buildGreetingText(context, dynamicTextColor),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                color: dynamicTextColor.withOpacity(0.86),
                splashRadius: 22,
                onPressed: widget.onSearchPressed,
                tooltip: 'بحث',
                style: IconButton.styleFrom(
                  backgroundColor: dynamicTextColor.withOpacity(0.03),
                  shape: const CircleBorder(),
                ),
              ),
              _buildAnimatedNotificationIcon(theme),
              const SizedBox(width: 10),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.2),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.7,
                  color: theme.dividerColor.withOpacity(0.10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildUserAvatar(ThemeData theme) {
    if (widget.userImageUrl != null && widget.userImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: theme.primaryColor.withOpacity(0.11),
        backgroundImage: NetworkImage(widget.userImageUrl!),
      );
    }
    // متدرج لوني مع الحرف الأول
    return CircleAvatar(
      radius: 22,
      backgroundColor: theme.primaryColor.withOpacity(0.08),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor, theme.primaryColorLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingText(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحبا بك الى منصة الجنيد التعليمية',
          style: Styles.style12(
            context,
          ).copyWith(color: textColor.withOpacity(0.53), fontFamily: 'Cairo'),
        ),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 450),
          style: Styles.style14(context).copyWith(
            fontWeight: FontWeight.w800,
            color: textColor,
            fontFamily: 'Cairo',
          ),
          child: Text(widget.userName),
        ),
      ],
    );
  }

  Widget _buildAnimatedNotificationIcon(ThemeData theme) {
    final hasNotifications = widget.notificationCount > 0;
    final iconColor = theme.colorScheme.onSurface.withOpacity(0.87);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: iconColor,
            splashRadius: 22,
            onPressed: widget.onNotificationPressed,
            tooltip: 'الإشعارات',
            style: IconButton.styleFrom(
              backgroundColor: iconColor.withOpacity(0.025),
              shape: const CircleBorder(),
            ),
          ),
          if (hasNotifications)
            Positioned(
              right: 3,
              top: 0,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: theme.colorScheme.background,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  child: Center(
                    child: Text(
                      widget.notificationCount > 99
                          ? "99+"
                          : widget.notificationCount.toString(),
                      style: Styles.style12(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
