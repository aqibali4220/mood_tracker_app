import 'package:flutter/material.dart';

import '../../contoller/app_controller.dart';
import '../../data/modal/app_modal.dart';
import 'face_widget.dart';

class MoodSelector extends StatelessWidget {
  final MoodState state;

  MoodSelector({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'HOW ARE YOU FEELING?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9BB5),
              letterSpacing: 2.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: moodOptions.length,
            itemBuilder: (context, index) {
              final mood = moodOptions[index];
              final isSelected = state.selectedMood == mood.type;

              return _MoodOption(
                moodData: mood,
                isSelected: isSelected,
                onTap: () => state.selectMood(mood.type),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MoodOption extends StatelessWidget {
  final MoodData moodData;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodOption({
    required this.moodData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? moodData.primaryColor.withOpacity(0.15)
                : const Color(0xFF1A1928),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? moodData.primaryColor.withOpacity(0.7)
                  : const Color(0xFF2E2C45),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? moodData.primaryColor.withOpacity(0.20)
                    : Colors.transparent,
                blurRadius: isSelected ? 14 : 0.1,
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: MoodFaceWidget(
                  moodType: moodData.type,
                  size: 52,
                  isSelected: isSelected,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? moodData.primaryColor
                      : const Color(0xFF6E6B85),
                  letterSpacing: 0.3,
                ),
                child: Text(moodData.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
