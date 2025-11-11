import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = '';
  bool _isEnglishToCreole = true;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> _translateText() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    String? result;
    if (_isEnglishToCreole) {
      result = await _dbHelper.getCreoleTranslation(input);
    } else {
      result = await _dbHelper.getEnglishTranslation(input);
    }

    setState(() {
      _translatedText = result ?? 'No translation found.';
    });
  }

  void _toggleDirection() {
    setState(() {
      _isEnglishToCreole = !_isEnglishToCreole;
      _inputController.clear();
      _translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002868), Color(0xFFCE1126)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Creole Companion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isEnglishToCreole
                            ? '🇺🇸 English → 🇭🇹 Kreyòl'
                            : '🇭🇹 Kreyòl → 🇺🇸 English',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleDirection,
                        icon: const Icon(
                          Icons.swap_horiz,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isEnglishToCreole ? 'English' : 'Kreyòl',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _inputController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Type text here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isEnglishToCreole ? 'Kreyòl' : 'English',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Container(
                    width: double.infinity,
                    height: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _translatedText,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: _translateText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002868),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Translate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
