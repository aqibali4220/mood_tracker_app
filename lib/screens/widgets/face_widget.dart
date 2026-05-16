import 'package:flutter/material.dart';

import '../../data/modal/app_modal.dart';
import '../../data/utils/painter.dart';


class MoodFaceWidget extends StatefulWidget {
  final MoodType moodType;
  final double size;
  final bool isSelected;
  final bool autoAnimate;
  final VoidCallback? onTap;

  const MoodFaceWidget({
    super.key,
    required this.moodType,
    this.size = 80,
    this.isSelected = false,
    this.autoAnimate = false,
    this.onTap,
  });

  @override
  State<MoodFaceWidget> createState() => _MoodFaceWidgetState();
}

class _MoodFaceWidgetState extends State<MoodFaceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _paintAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _paintAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.autoAnimate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Called externally to trigger a pulse animation
  void pulse() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final moodData = getMoodData(widget.moodType);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: widget.isSelected
                  ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: moodData.primaryColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              )
                  : null,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: MoodFacePainter(
                  moodType: widget.moodType,
                  faceColor: moodData.primaryColor,
                  outlineColor: moodData.primaryColor,
                  animationValue: _paintAnim.value,
                  isSelected: widget.isSelected,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A tappable version that pulses on tap — used in the timeline
class TappableMoodFace extends StatefulWidget {
  final MoodType moodType;
  final double size;

  const TappableMoodFace({
    super.key,
    required this.moodType,
    this.size = 60,
  });

  @override
  State<TappableMoodFace> createState() => _TappableMoodFaceState();
}

class _TappableMoodFaceState extends State<TappableMoodFace>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 35),
      TweenSequenceItem(
          tween: Tween(begin: 1.35, end: 0.90)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 0.90, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 40),
    ]).animate(_controller);

    _glow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final moodData = getMoodData(widget.moodType);

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                    moodData.primaryColor.withOpacity(0.45 * _glow.value),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: MoodFacePainter(
                  moodType: widget.moodType,
                  faceColor: moodData.primaryColor,
                  outlineColor: moodData.primaryColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
