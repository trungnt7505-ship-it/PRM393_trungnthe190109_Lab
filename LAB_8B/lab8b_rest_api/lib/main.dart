// ============================================================================
// LAB 8B - STEP 1: CHOOSE A SCENARIO
// Scenario A chosen: Weather Companion App (helps users decide what to wear,
// whether to take an umbrella, and if it's a good day for outdoor activities).
// ============================================================================
import 'package:flutter/material.dart';
import 'screens/weather_home_screen.dart';

void main() {
  runApp(const WeatherCompanionApp());
}

class WeatherCompanionApp extends StatelessWidget {
  const WeatherCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Companion - REST API Lab 8B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const WeatherHomeScreen(),
    );
  }
}
