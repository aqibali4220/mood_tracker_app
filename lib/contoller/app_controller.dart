import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/modal/app_modal.dart';


class MoodState extends ChangeNotifier {
  static const String _storageKey = 'mood_entries_v1';

  List<MoodEntry> _entries = [];
  bool _isLoading = true;
  MoodType? _selectedMood;

  List<MoodEntry> get entries => List.unmodifiable(_entries);

  /// Last 7 entries, most recent first
  List<MoodEntry> get recentEntries =>
      _entries.take(7).toList();

  bool get isLoading => _isLoading;
  MoodType? get selectedMood => _selectedMood;
  bool get hasEntries => _entries.isNotEmpty;

  MoodState() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_storageKey) ?? [];
      _entries = raw
          .map((s) => MoodEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      _entries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, raw);
  }

  void selectMood(MoodType type) {
    _selectedMood = type;
    notifyListeners();
  }

  Future<void> logMood({String? note}) async {
    if (_selectedMood == null) return;

    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedMood!,
      timestamp: DateTime.now(),
      note: note,
    );

    _entries.insert(0, entry);
    _selectedMood = null;
    notifyListeners();
    await _saveEntries();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _saveEntries();
  }

  /// Seed with demo data for first-time users
  Future<void> seedDemoData() async {
    if (_entries.isNotEmpty) return;

    final now = DateTime.now();
    final demoMoods = [
      MoodType.happy,
      MoodType.neutral,
      MoodType.ecstatic,
      MoodType.sad,
      MoodType.happy,
      MoodType.neutral,
      MoodType.awful,
    ];

    for (int i = 0; i < demoMoods.length; i++) {
      _entries.add(MoodEntry(
        id: 'demo_$i',
        type: demoMoods[i],
        timestamp: now.subtract(Duration(days: i, hours: i * 2)),
        note: null,
      ));
    }

    _entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
    await _saveEntries();
  }
}
