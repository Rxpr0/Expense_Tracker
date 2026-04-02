import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fill.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, animatedFill, _) {
            final scheme = Theme.of(context).colorScheme;
            return FractionallySizedBox(
              heightFactor: animatedFill, // 0 <> 1
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            scheme.secondary.withValues(alpha: 0.95),
                            scheme.tertiary.withValues(alpha: 0.75),
                          ]
                        : [
                            scheme.primary.withValues(alpha: 0.85),
                            scheme.secondary.withValues(alpha: 0.55),
                          ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}