import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../contoller/app_controller.dart';
import '../../data/modal/app_modal.dart';


class LogMoodButton extends StatefulWidget {
  final MoodState state;

  const LogMoodButton({super.key, required this.state});

  @override
  State<LogMoodButton> createState() => _LogMoodButtonState();
}

class _LogMoodButtonState extends State<LogMoodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.93,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLog() async {
    if (_isLogging || widget.state.selectedMood == null) return;
    setState(() => _isLogging = true);

    HapticFeedback.mediumImpact();
    await _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 60));
    await _controller.forward();

    await widget.state.logMood();
    setState(() => _isLogging = false);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = widget.state.selectedMood != null;
    final moodData =
    hasSelection ? getMoodData(widget.state.selectedMood!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: GestureDetector(
          onTap: _handleLog,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            height: 60,
            decoration: BoxDecoration(
              gradient: hasSelection
                  ? LinearGradient(
                colors: [
                  moodData!.primaryColor,
                  moodData.accentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              color: hasSelection ? null : const Color(0xFF252438),
              borderRadius: BorderRadius.circular(18),
              boxShadow: hasSelection
                  ? [
                BoxShadow(
                  color: moodData!.primaryColor.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color:
                  hasSelection ? const Color(0xFF0F0E17) : const Color(0xFF4A4766),
                ),
                child: Text(
                  hasSelection ? 'LOG THIS MOOD' : 'SELECT A MOOD',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
