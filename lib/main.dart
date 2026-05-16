import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/mood_tracker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodscape',
      debugShowCheckedModeBanner: false,
      home: const MoodTrackerScreen(),
    );
  }
}

