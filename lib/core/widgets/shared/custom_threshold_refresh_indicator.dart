import 'package:flutter/material.dart';

class CustomThresholdRefreshIndicator extends StatefulWidget {
  const CustomThresholdRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.threshold = 140.0,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  });

  final Widget child;
  final double displacement;
  final double edgeOffset;
  final RefreshCallback onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final RefreshIndicatorTriggerMode triggerMode;
  final double elevation;
  final double threshold;

  @override
  State<CustomThresholdRefreshIndicator> createState() =>
      _CustomThresholdRefreshIndicatorState();
}

class _CustomThresholdRefreshIndicatorState
    extends State<CustomThresholdRefreshIndicator> {
  double _dragDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification ||
            notification is OverscrollNotification) {
          final metrics = notification.metrics;
          if (metrics.pixels < 0) {
            final overscroll = metrics.pixels.abs();
            if (overscroll > _dragDistance) {
              _dragDistance = overscroll;
            }
          }
        } else if (notification is ScrollStartNotification) {
          _dragDistance = 0.0;
        }
        return false; // Allow scroll events to bubble up to RefreshIndicator
      },
      child: RefreshIndicator(
        displacement: widget.displacement,
        edgeOffset: widget.edgeOffset,
        color: widget.color,
        backgroundColor: widget.backgroundColor,
        notificationPredicate: widget.notificationPredicate,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
        strokeWidth: widget.strokeWidth,
        triggerMode: widget.triggerMode,
        elevation: widget.elevation,
        onRefresh: () async {
          if (_dragDistance < widget.threshold) {
            // Cancel the refresh action (complete immediately)
            return;
          }
          await widget.onRefresh();
        },
        child: widget.child,
      ),
    );
  }
}
