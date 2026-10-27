import 'dart:math' as math;

import 'package:flutter/material.dart';

// Paints the eight-point star (two overlapping squares) with optional rings used as decoration.
class IslamicStarPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool withRings;
  final double cornerRadius;
  final double innerRingRatio;

  // Creates the painter with stroke color, width and ring option.
  const IslamicStarPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.withRings = false,
    this.cornerRadius = 0,
    this.innerRingRatio = 0.15,
  });

  // Draws both rotated squares and, when enabled, two concentric rings.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final center = size.center(Offset.zero);
    final side = size.shortestSide * 0.6;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: side, height: side),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(rect, paint);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawRRect(rect, paint);
    canvas.restore();

    if (withRings) {
      canvas.drawCircle(center, size.shortestSide * innerRingRatio, paint);
      canvas.drawCircle(center, size.shortestSide * 0.425, paint);
    }
  }

  // Repaints only when the visual parameters change.
  @override
  bool shouldRepaint(covariant IslamicStarPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.withRings != withRings ||
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.innerRingRatio != innerRingRatio;
}

// Displays a decorative eight-point star of the given size and opacity.
class IslamicStar extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final bool withRings;
  final double opacity;
  final double innerRingRatio;

  // Creates a decorative star.
  const IslamicStar({
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = 1,
    this.withRings = false,
    this.opacity = 1,
    this.innerRingRatio = 0.15,
  });

  // Builds the star inside an excluded-from-semantics box.
  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          size: Size.square(size),
          painter: IslamicStarPainter(
            color: color,
            strokeWidth: strokeWidth,
            withRings: withRings,
            innerRingRatio: innerRingRatio,
          ),
        ),
      ),
    );
  }
}
