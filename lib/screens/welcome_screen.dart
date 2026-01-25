import 'package:flutter/material.dart';
import '../services/audio_controller.dart'; 
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the controller
    final audioCtrl = AudioController();
    // Check if music is currently playing to decide which icon to show
    bool isMusicOn = audioCtrl.isPlaying;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/citadelle.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay
          Container(color: Colors.black.withOpacity(0.4)),

          // --- Music Toggle Button (Top Right) ---
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: Icon(
                isMusicOn ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                // Toggle music and refresh the UI icon
                audioCtrl.toggleMusic().then((_) {
                  setState(() {}); 
                });
              },
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Creole Companion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "English ↔ Haitian Creole Translator",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}