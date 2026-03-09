import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const NeuraLiftApp());
}

class NeuraLiftApp extends StatelessWidget {
  const NeuraLiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuraLift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D1421),
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
    );
  }
}
