import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

class FancyFloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FancyFloatingNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<FancyFloatingNavBar> createState() => _FancyFloatingNavBarState();
}

class _FancyFloatingNavBarState extends State<FancyFloatingNavBar>
    with TickerProviderStateMixin {
  late final List<IconData> icons = [
    Icons.home_outlined,
    Icons.play_circle_fill_rounded,
    Icons.bookmark_rounded,
    Icons.person_rounded,
  ];
  late final List<String> labels = [
    'الرئيسية',
    'الدورات',
    'المحفوظات',
    'الحساب',
  ];

  late final List<AnimationController> _iconControllers;

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      icons.length,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
        lowerBound: 0.9, // تم رفعه قليلاً لتقليل التضخم
        upperBound: 1.1, // تم تقليله ليناسب الارتفاع الصغير
      )..value = i == widget.selectedIndex ? 1.1 : 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant FancyFloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _iconControllers[widget.selectedIndex].forward(from: 0.9);
      _iconControllers[oldWidget.selectedIndex].reverse();
    }
  }

  @override
  void dispose() {
    for (var c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: context.surfaceContainer,

          borderRadius: BorderRadius.circular(30),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (i) {
            final bool isActive = i == widget.selectedIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onItemSelected(i),
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: AnimatedContainer(
                    width: isActive ? 100 : 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: isActive ? 6 : 0,
                    ),
                    decoration: isActive
                        ? BoxDecoration(
                            color: context.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _iconControllers[i],
                          child: Icon(
                            icons[i],
                            color: isActive
                                ? context.primary
                                : Colors.grey[context.isDarkMode ? 200 : 600],
                            size: 22,
                          ),
                        ),
                        if (isActive)
                          Flexible(
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    labels[i],
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.clip,
                                    style: context.textTheme.labelMedium!
                                        .copyWith(color: context.primary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
