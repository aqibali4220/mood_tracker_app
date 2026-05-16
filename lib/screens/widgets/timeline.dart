import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../contoller/app_controller.dart';
import '../../data/modal/app_modal.dart';
import 'face_widget.dart';


class MoodTimeline extends StatelessWidget {
  final MoodState state;

  const MoodTimeline({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final entries = state.recentEntries;

    if (entries.isEmpty) {
      return _EmptyTimeline();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'RECENT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF9E9BB5),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF252438),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${entries.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF9E9BB5),
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _TimelineCard(
                entry: entries[index],
                isLatest: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final MoodEntry entry;
  final bool isLatest;

  const _TimelineCard({required this.entry, required this.isLatest});

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(entryDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }

  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    final moodData = getMoodData(entry.type);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1928),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLatest
                ? moodData.primaryColor.withOpacity(0.5)
                : moodData.primaryColor.withOpacity(0.15),
            width: isLatest ? 1.5 : 1,
          ),
          boxShadow: isLatest
              ? [
            BoxShadow(
              color: moodData.primaryColor.withOpacity(0.12),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Colored accent line at top
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    moodData.primaryColor.withOpacity(0),
                    moodData.primaryColor,
                    moodData.primaryColor.withOpacity(0),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            const SizedBox(height: 10),
            // Tappable face
            TappableMoodFace(
              moodType: entry.type,
              size: 58,
            ),
            const SizedBox(height: 8),
            // Date label
            Text(
              _formatDate(entry.timestamp),
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: moodData.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            // Time label
            Text(
              _formatTime(entry.timestamp),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 10,
                color: Color(0xFF6E6B85),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9BB5),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1928),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF2E2C45),
              ),
            ),
            child: const Center(
              child: Text(
                'Log your first mood above ↑',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 13,
                  color: Color(0xFF6E6B85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
