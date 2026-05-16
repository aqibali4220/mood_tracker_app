import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/widgets/stats_card_screen.dart';

import '../../contoller/app_controller.dart';
import '../../data/modal/app_modal.dart';

class StatsStrip extends StatelessWidget {
  final MoodState state;

  const StatsStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final entries = state.entries;
    if (entries.isEmpty) return const SizedBox.shrink();

    final total = entries.length;
    // Find most common mood
    final counts = <int, int>{};
    for (final e in entries) {
      counts[e.type.index] = (counts[e.type.index] ?? 0) + 1;
    }
    final topIdx = counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final topMood = moodOptions[topIdx];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OVERVIEW',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9BB5),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              StatCard(
                label: 'ENTRIES',
                value: total.toString(),
                color: const Color(0xFF8ECAE6),
              ),
              const SizedBox(width: 12),
              StatCard(
                label: 'TOP MOOD',
                value: topMood.label,
                color: topMood.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}