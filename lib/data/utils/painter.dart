import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../modal/app_modal.dart';


/// Draws a mood face entirely with canvas drawing primitives.
/// No images, emoji, or icon fonts — only drawCircle, drawArc, drawPath, drawOval.
class MoodFacePainter extends CustomPainter {
  final MoodType moodType;
  final Color faceColor;
  final Color outlineColor;
  final double animationValue; // 0.0 → 1.0 for entrance/pulse animations
  final bool isSelected;

  MoodFacePainter({
    required this.moodType,
    required this.faceColor,
    required this.outlineColor,
    this.animationValue = 1.0,
    this.isSelected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.85 * animationValue;

    // ── Face circle ─────────────────────────────────────────────────────────
    final facePaint = Paint()
      ..color = faceColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final faceOutlinePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, faceOutlinePaint);

    // Scale all face features relative to radius
    _drawExpression(canvas, center, radius, size);
  }

  void _drawExpression(Canvas canvas, Offset center, double radius, Size size) {
    switch (moodType) {
      case MoodType.ecstatic:
        _drawEcstatic(canvas, center, radius);
        break;
      case MoodType.happy:
        _drawHappy(canvas, center, radius);
        break;
      case MoodType.neutral:
        _drawNeutral(canvas, center, radius);
        break;
      case MoodType.sad:
        _drawSad(canvas, center, radius);
        break;
      case MoodType.awful:
        _drawAwful(canvas, center, radius);
        break;
    }
  }

  Paint _featurePaint(double strokeWidth) => Paint()
    ..color = outlineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fillPaint() => Paint()
    ..color = outlineColor
    ..style = PaintingStyle.fill;

  // ── ECSTATIC ─────────────────────────────────────────────────────────────
  // Wide open grin, star-shaped eyes, raised arched eyebrows, rosy cheeks
  void _drawEcstatic(Canvas canvas, Offset center, double r) {
    final sw = r * 0.09;
    final paint = _featurePaint(sw);

    // Raised arched eyebrows
    final browY = center.dy - r * 0.38;
    final browPaint = _featurePaint(sw * 0.9);
    final leftBrowPath = Path()
      ..moveTo(center.dx - r * 0.52, browY + r * 0.06)
      ..quadraticBezierTo(
          center.dx - r * 0.30, browY - r * 0.10, center.dx - r * 0.08, browY + r * 0.06);
    final rightBrowPath = Path()
      ..moveTo(center.dx + r * 0.08, browY + r * 0.06)
      ..quadraticBezierTo(
          center.dx + r * 0.30, browY - r * 0.10, center.dx + r * 0.52, browY + r * 0.06);
    canvas.drawPath(leftBrowPath, browPaint);
    canvas.drawPath(rightBrowPath, browPaint);

    // Star/sparkle eyes using drawPath
    _drawStarEye(canvas, Offset(center.dx - r * 0.32, center.dy - r * 0.12), r * 0.16);
    _drawStarEye(canvas, Offset(center.dx + r * 0.32, center.dy - r * 0.12), r * 0.16);

    // Wide open grin — big upward arc
    final smilePath = Path();
    final smileLeft = Offset(center.dx - r * 0.52, center.dy + r * 0.10);
    final smileRight = Offset(center.dx + r * 0.52, center.dy + r * 0.10);
    final smileBottom = Offset(center.dx, center.dy + r * 0.62);
    smilePath.moveTo(smileLeft.dx, smileLeft.dy);
    smilePath.quadraticBezierTo(smileBottom.dx, smileBottom.dy, smileRight.dx, smileRight.dy);

    // Close the mouth to make it open-mouthed
    smilePath.quadraticBezierTo(
        center.dx, center.dy + r * 0.42, smileLeft.dx, smileLeft.dy);
    final mouthFill = Paint()
      ..color = outlineColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawPath(smilePath, mouthFill);
    canvas.drawPath(smilePath, paint);

    // Rosy cheeks
    final cheekPaint = Paint()
      ..color = outlineColor.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx - r * 0.58, center.dy + r * 0.05),
          width: r * 0.30,
          height: r * 0.18),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx + r * 0.58, center.dy + r * 0.05),
          width: r * 0.30,
          height: r * 0.18),
      cheekPaint,
    );
  }

  void _drawStarEye(Canvas canvas, Offset center, double size) {
    final paint = _fillPaint();
    final path = Path();
    const int points = 6;
    const double outerR = 1.0;
    const double innerR = 0.45;

    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final rad = (i % 2 == 0) ? outerR * size : innerR * size;
      final x = center.dx + rad * math.cos(angle);
      final y = center.dy + rad * math.sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // ── HAPPY ─────────────────────────────────────────────────────────────────
  // Classic smile, dot eyes, gentle brow lift
  void _drawHappy(Canvas canvas, Offset center, double r) {
    final sw = r * 0.09;
    final paint = _featurePaint(sw);

    // Soft eyebrows — slight upward curve
    final browY = center.dy - r * 0.35;
    final browPaint = _featurePaint(sw * 0.85);
    final leftBrow = Path()
      ..moveTo(center.dx - r * 0.48, browY + r * 0.04)
      ..quadraticBezierTo(
          center.dx - r * 0.28, browY - r * 0.06, center.dx - r * 0.10, browY + r * 0.04);
    final rightBrow = Path()
      ..moveTo(center.dx + r * 0.10, browY + r * 0.04)
      ..quadraticBezierTo(
          center.dx + r * 0.28, browY - r * 0.06, center.dx + r * 0.48, browY + r * 0.04);
    canvas.drawPath(leftBrow, browPaint);
    canvas.drawPath(rightBrow, browPaint);

    // Round eyes
    canvas.drawCircle(
        Offset(center.dx - r * 0.30, center.dy - r * 0.10), r * 0.10, _fillPaint());
    canvas.drawCircle(
        Offset(center.dx + r * 0.30, center.dy - r * 0.10), r * 0.10, _fillPaint());

    // Classic curved smile
    final smileRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + r * 0.08),
      width: r * 0.90,
      height: r * 0.55,
    );
    canvas.drawArc(smileRect, 0, math.pi, false, paint);
  }

  // ── NEUTRAL ───────────────────────────────────────────────────────────────
  // Flat straight mouth, half-closed eyes, level brows
  void _drawNeutral(Canvas canvas, Offset center, double r) {
    final sw = r * 0.09;
    final paint = _featurePaint(sw);

    // Level eyebrows — perfectly horizontal
    final browY = center.dy - r * 0.35;
    canvas.drawLine(
      Offset(center.dx - r * 0.48, browY),
      Offset(center.dx - r * 0.10, browY),
      _featurePaint(sw * 0.85),
    );
    canvas.drawLine(
      Offset(center.dx + r * 0.10, browY),
      Offset(center.dx + r * 0.48, browY),
      _featurePaint(sw * 0.85),
    );

    // Half-lidded eyes — circle with horizontal line across top half
    final eyeY = center.dy - r * 0.10;
    final eyeRadius = r * 0.12;
    canvas.drawCircle(Offset(center.dx - r * 0.30, eyeY), eyeRadius, _fillPaint());
    canvas.drawCircle(Offset(center.dx + r * 0.30, eyeY), eyeRadius, _fillPaint());

    // Eyelid overlay to make them look half-closed
    final lidPaint = Paint()
      ..color = faceColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(center.dx - r * 0.30 - eyeRadius, eyeY - eyeRadius,
            eyeRadius * 2, eyeRadius),
        lidPaint);
    canvas.drawRect(
        Rect.fromLTWH(center.dx + r * 0.30 - eyeRadius, eyeY - eyeRadius,
            eyeRadius * 2, eyeRadius),
        lidPaint);

    // Straight flat mouth
    canvas.drawLine(
      Offset(center.dx - r * 0.35, center.dy + r * 0.28),
      Offset(center.dx + r * 0.35, center.dy + r * 0.28),
      paint,
    );
  }

  // ── SAD ───────────────────────────────────────────────────────────────────
  // Downward curved mouth, drooping brows, tear drop
  void _drawSad(Canvas canvas, Offset center, double r) {
    final sw = r * 0.09;
    final paint = _featurePaint(sw);

    // Drooping inner brows — angled down toward nose
    final browPaint = _featurePaint(sw * 0.85);
    final browY = center.dy - r * 0.30;
    final leftSadBrow = Path()
      ..moveTo(center.dx - r * 0.48, browY - r * 0.04)
      ..quadraticBezierTo(
          center.dx - r * 0.28, browY + r * 0.06, center.dx - r * 0.10, browY + r * 0.10);
    final rightSadBrow = Path()
      ..moveTo(center.dx + r * 0.10, browY + r * 0.10)
      ..quadraticBezierTo(
          center.dx + r * 0.28, browY + r * 0.06, center.dx + r * 0.48, browY - r * 0.04);
    canvas.drawPath(leftSadBrow, browPaint);
    canvas.drawPath(rightSadBrow, browPaint);

    // Sad eyes — slightly oval, downturned outer corners
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx - r * 0.30, center.dy - r * 0.10),
            width: r * 0.22,
            height: r * 0.26),
        _fillPaint());
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx + r * 0.30, center.dy - r * 0.10),
            width: r * 0.22,
            height: r * 0.26),
        _fillPaint());

    // Tear drop under left eye
    _drawTear(canvas, Offset(center.dx - r * 0.28, center.dy + r * 0.05), r * 0.10);

    // Downward curved frown
    final frownRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + r * 0.55),
      width: r * 0.75,
      height: r * 0.45,
    );
    canvas.drawArc(frownRect, math.pi, math.pi, false, paint);
  }

  void _drawTear(Canvas canvas, Offset top, double size) {
    final path = Path();
    path.moveTo(top.dx, top.dy);
    path.cubicTo(
      top.dx + size * 0.8, top.dy + size * 0.8,
      top.dx + size * 0.8, top.dy + size * 1.6,
      top.dx, top.dy + size * 2.0,
    );
    path.cubicTo(
      top.dx - size * 0.8, top.dy + size * 1.6,
      top.dx - size * 0.8, top.dy + size * 0.8,
      top.dx, top.dy,
    );
    path.close();
    final tearPaint = Paint()
      ..color = outlineColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, tearPaint);
  }

  // ── AWFUL ─────────────────────────────────────────────────────────────────
  // Deep frown, furrowed angry brows meeting in middle, X eyes, zigzag mouth
  void _drawAwful(Canvas canvas, Offset center, double r) {
    final sw = r * 0.09;
    final paint = _featurePaint(sw);

    // Angry furrowed brows — V-shape meeting near the nose bridge
    final browPaint = _featurePaint(sw);
    final leftAngryBrow = Path()
      ..moveTo(center.dx - r * 0.52, center.dy - r * 0.40)
      ..lineTo(center.dx - r * 0.10, center.dy - r * 0.28);
    final rightAngryBrow = Path()
      ..moveTo(center.dx + r * 0.10, center.dy - r * 0.28)
      ..lineTo(center.dx + r * 0.52, center.dy - r * 0.40);
    canvas.drawPath(leftAngryBrow, browPaint);
    canvas.drawPath(rightAngryBrow, browPaint);

    // X eyes
    _drawXEye(canvas, Offset(center.dx - r * 0.30, center.dy - r * 0.10), r * 0.14, sw);
    _drawXEye(canvas, Offset(center.dx + r * 0.30, center.dy - r * 0.10), r * 0.14, sw);

    // Zigzag / jagged mouth
    final zigzagPath = Path();
    final mouthY = center.dy + r * 0.35;
    final mouthLeft = center.dx - r * 0.40;
    final segW = r * 0.20;
    zigzagPath.moveTo(mouthLeft, mouthY);
    for (int i = 0; i < 4; i++) {
      final x1 = mouthLeft + segW * i + segW / 2;
      final y1 = mouthY + (i % 2 == 0 ? r * 0.12 : -r * 0.12);
      final x2 = mouthLeft + segW * (i + 1);
      zigzagPath.lineTo(x1, y1);
      zigzagPath.lineTo(x2, mouthY);
    }
    canvas.drawPath(zigzagPath, paint);
  }

  void _drawXEye(Canvas canvas, Offset center, double size, double sw) {
    final xPaint = _featurePaint(sw);
    canvas.drawLine(
        Offset(center.dx - size, center.dy - size),
        Offset(center.dx + size, center.dy + size),
        xPaint);
    canvas.drawLine(
        Offset(center.dx + size, center.dy - size),
        Offset(center.dx - size, center.dy + size),
        xPaint);
    // Small circle outline for the eye socket
    canvas.drawCircle(center, size * 1.1, _featurePaint(sw * 0.5));
  }

  @override
  bool shouldRepaint(MoodFacePainter oldDelegate) =>
      oldDelegate.moodType != moodType ||
          oldDelegate.animationValue != animationValue ||
          oldDelegate.isSelected != isSelected;
}
