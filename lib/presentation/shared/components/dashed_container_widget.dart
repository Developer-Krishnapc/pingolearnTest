import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  const DashedBorderContainer({
    super.key,
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    double dashOffset = 0;
    final totalDashLength = dashLength + gapLength;

    for (final pathMetric in path.computeMetrics()) {
      while (dashOffset < pathMetric.length) {
        final currentLength = dashOffset + dashLength;
        final start = dashOffset;
        final end = currentLength < pathMetric.length
            ? currentLength
            : pathMetric.length;
        canvas.drawPath(
          pathMetric.extractPath(start, end),
          paint,
        );
        dashOffset += totalDashLength;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
