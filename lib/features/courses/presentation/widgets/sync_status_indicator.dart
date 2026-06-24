import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';

enum SyncStatus { hidden, syncing, success, error }

class SyncStatusIndicator extends StatefulWidget {
  final bool isUpdating;
  final String? errorMessage;

  const SyncStatusIndicator({
    super.key,
    required this.isUpdating,
    this.errorMessage,
  });

  @override
  State<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends State<SyncStatusIndicator>
    with SingleTickerProviderStateMixin {
  SyncStatus _status = SyncStatus.hidden;
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    if (widget.isUpdating) {
      _show(SyncStatus.syncing);
    }
  }

  @override
  void didUpdateWidget(SyncStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUpdating && !oldWidget.isUpdating) {
      _show(SyncStatus.syncing);
    } else if (!widget.isUpdating && oldWidget.isUpdating) {
      if (widget.errorMessage != null) {
        _show(SyncStatus.error);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !widget.isUpdating) {
            _hide();
          }
        });
      } else {
        _show(SyncStatus.success);
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && !widget.isUpdating) {
            _hide();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _show(SyncStatus status) {
    if (!mounted) return;
    setState(() {
      _status = status;
    });
    _animController.forward();
  }

  void _hide() {
    if (!mounted) return;
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _status = SyncStatus.hidden;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_status == SyncStatus.hidden) {
      return const SizedBox.shrink();
    }

    Color themeColor;
    String text;
    IconData icon;
    bool showPulse = false;

    switch (_status) {
      case SyncStatus.syncing:
        themeColor = context.primary;
        text = 'جاري تحديث البيانات...';
        icon = Icons.sync_rounded;
        showPulse = true;
        break;
      case SyncStatus.success:
        themeColor = Colors.green;
        text = 'تم تحديث البيانات بنجاح';
        icon = Icons.check_circle_rounded;
        break;
      case SyncStatus.error:
        themeColor = Colors.red;
        text = widget.errorMessage ?? 'تعذر تحديث البيانات';
        icon = Icons.error_rounded;
        break;
      case SyncStatus.hidden:
        return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: themeColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.surface.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: themeColor.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showPulse)
                        _RotatingIcon(icon: Icons.sync_rounded, color: themeColor)
                      else
                        Icon(icon, color: themeColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RotatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _RotatingIcon({required this.icon, required this.color});

  @override
  State<_RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<_RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(widget.icon, color: widget.color, size: 18),
    );
  }
}
