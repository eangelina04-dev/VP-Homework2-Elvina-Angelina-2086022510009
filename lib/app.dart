import 'package:flutter/material.dart';
import 'features/timeline/presentation/timeline_screen.dart';

class StarWarsApp extends StatelessWidget {
  const StarWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Chronology',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1A237E),
        useMaterial3: true,
      ),
      home: const TimelineScreen(),
    );
  }
}