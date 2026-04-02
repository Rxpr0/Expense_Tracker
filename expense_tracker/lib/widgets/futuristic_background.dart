import 'dart:math' as math;

import 'package:flutter/material.dart';

class FuturisticBackground extends StatelessWidget {
  const FuturisticBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final blobA = isDark ? scheme.primary : scheme.primaryContainer;
    final blobB = isDark ? scheme.tertiary : scheme.secondaryContainer;

    return Stack(
      children: [
        Positioned.fill(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 12),
            curve: Curves.easeInOut,
            builder: (context, t, _) {
              final driftX = math.sin(t * math.pi * 2) * 18;
              final driftY = math.cos(t * math.pi * 2) * 14;

              return Stack(
                children: [
                  _Blob(
                    color: blobA.withValues(alpha: isDark ? 0.16 : 0.22),
                    size: 360,
                    left: -140 + driftX,
                    top: -120 + driftY,
                  ),
                  _Blob(
                    color: blobB.withValues(alpha: isDark ? 0.10 : 0.18),
                    size: 280,
                    right: -110 - driftX,
                    bottom: 30 + driftY,
                  ),
                ],
              );
            },
          ),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.color,
    required this.size,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  final Color color;
  final double size;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: 0),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
