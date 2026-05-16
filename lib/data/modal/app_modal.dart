import 'package:flutter/material.dart';

enum MoodType {
  ecstatic,
  happy,
  neutral,
  sad,
  awful,
}

class MoodData {
  final MoodType type;
  final String label;
  final Color primaryColor;
  final Color accentColor;
  final String emoji;

  const MoodData({
    required this.type,
    required this.label,
    required this.primaryColor,
    required this.accentColor,
    required this.emoji,
  });
}

const List<MoodData> moodOptions = [
  MoodData(
    type: MoodType.ecstatic,
    label: 'Ecstatic',
    primaryColor: Color(0xFFFFD166),
    accentColor: Color(0xFFFF9F1C),
    emoji: '🤩',
  ),
  MoodData(
    type: MoodType.happy,
    label: 'Happy',
    primaryColor: Color(0xFF06D6A0),
    accentColor: Color(0xFF05A57A),
    emoji: '😊',
  ),
  MoodData(
    type: MoodType.neutral,
    label: 'Neutral',
    primaryColor: Color(0xFF8ECAE6),
    accentColor: Color(0xFF219EBC),
    emoji: '😐',
  ),
  MoodData(
    type: MoodType.sad,
    label: 'Sad',
    primaryColor: Color(0xFFBB8FCE),
    accentColor: Color(0xFF8E44AD),
    emoji: '😔',
  ),
  MoodData(
    type: MoodType.awful,
    label: 'Awful',
    primaryColor: Color(0xFFEF476F),
    accentColor: Color(0xFFB5203F),
    emoji: '😞',
  ),
];

MoodData getMoodData(MoodType type) =>
    moodOptions.firstWhere((m) => m.type == type);

class MoodEntry {
  final String id;
  final MoodType type;
  final DateTime timestamp;
  final String? note;

  MoodEntry({
    required this.id,
    required this.type,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'timestamp': timestamp.toIso8601String(),
    'note': note,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    id: json['id'] as String,
    type: MoodType.values[json['type'] as int],
    timestamp: DateTime.parse(json['timestamp'] as String),
    note: json['note'] as String?,
  );
}
