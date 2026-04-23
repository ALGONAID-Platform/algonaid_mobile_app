import 'package:flutter/material.dart';

class AppHero extends StatelessWidget {
  final String tag;
  final Widget child;
  // أضفنا خصائص إضافية للتحكم الكامل
  final bool useFlightShuttle; 

  const AppHero({
    super.key,
    required this.tag,
    required this.child,
    this.useFlightShuttle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: useFlightShuttle 
          ? (flightContext, animation, direction, fromContext, toContext) {
              return Material(
                color: Colors.transparent,
                child: toContext.widget,
              );
            }
          : null,
      placeholderBuilder: (context, size, widget) {
        return Opacity(opacity: 0.0, child: widget);
      },
      child: Material( 
        color: Colors.transparent, 
        child: child,
      ),
    );
  }
}