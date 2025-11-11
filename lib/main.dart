import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const CreoleCompanion());
}

class CreoleCompanion extends StatelessWidget {
  const CreoleCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creole Companion',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const WelcomeScreen(),
    );
  }
}
