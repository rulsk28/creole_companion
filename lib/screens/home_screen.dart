
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/database_helper.dart';
import '../services/google_translate_service.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _inputController = TextEditingController();
  String _outputText = "";
  bool _englishToCreole = true;
  bool _loading = false;

  
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );

    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      localeId: _englishToCreole ? "en_US" : "ht_HT",
      onResult: (val) {
        setState(() {
          _inputController.text = val.recognizedWords;
        });
      },
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _translate() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() => _loading = true);

    final db = DatabaseHelper.instance;

    String? localResult = _englishToCreole
        ? await db.getCreole(text)
        : await db.getEnglish(text);

    if (localResult == null) {
      final apiResult = await GoogleTranslateService.translate(
        text: text,
        from: _englishToCreole ? "en" : "ht",
        to: _englishToCreole ? "ht" : "en",
      );
      localResult = apiResult ?? "No translation found.";
    }

    await db.saveHistory(
      text,
      localResult,
      _englishToCreole ? "EN → HT" : "HT → EN",
    );

    setState(() {
      _outputText = localResult!;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          },
        ),
      ),

      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00209F), Color(0xFFCE1126)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Creole Companion",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.history,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HistoryScreen(),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.star,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FavoritesScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 24),

                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SwitchListTile(
                          title: Text(
                            _englishToCreole
                                ? "English → Haitian Creole"
                                : "Haitian Creole → English",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          value: _englishToCreole,
                          onChanged: (v) =>
                              setState(() => _englishToCreole = v),
                          activeColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      TextField(
                        controller: _inputController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Enter text or speak…",
                          labelStyle:
                              const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_isListening) {
                                _stopListening();
                              } else {
                                _startListening();
                              }
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _loading ? null : _translate,
                          child: _loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  "Translate",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _outputText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WelcomeScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Back to Welcome Screen",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
