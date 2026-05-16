import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/widgets/app_head.dart';
import 'package:mood_tracker/screens/widgets/mood_button.dart';
import 'package:mood_tracker/screens/widgets/mood_selector.dart';
import 'package:mood_tracker/screens/widgets/stats_strip_screen.dart';
import 'package:mood_tracker/screens/widgets/timeline.dart';

import '../contoller/app_controller.dart';
import '../data/utils/app_theme.dart';


class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
    with SingleTickerProviderStateMixin {
  late final MoodState _moodState;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _moodState = MoodState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Seed demo data for first-time launch
    _moodState.addListener(() {
      if (!_moodState.isLoading && mounted) {
        _moodState.seedDemoData();
        _fadeController.forward();
      }
    });

    // Also trigger if already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_moodState.isLoading) {
        _moodState.seedDemoData();
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _moodState.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _moodState,
          builder: (context, _) {
            if (_moodState.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFD166),
                  strokeWidth: 2,
                ),
              );
            }

            return FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Header ───────────────────────────────────────────
                    const AppHeader(),

                    const SizedBox(height: 36),

                    // ── Divider ──────────────────────────────────────────
                    _buildDivider(),

                    const SizedBox(height: 28),

                    // ── Mood selector row ────────────────────────────────
                    MoodSelector(state: _moodState),

                    const SizedBox(height: 24),

                    // ── Log button ───────────────────────────────────────
                    LogMoodButton(state: _moodState),

                    const SizedBox(height: 36),

                    // ── Divider ──────────────────────────────────────────
                    _buildDivider(),

                    const SizedBox(height: 28),

                    // ── Timeline ─────────────────────────────────────────
                    MoodTimeline(state: _moodState),

                    const SizedBox(height: 36),

                    // ── Stats strip ──────────────────────────────────────
                    StatsStrip(state: _moodState),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Color(0xFF2E2C45),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
