import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'services/audio_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await AudioController().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creole Companion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
