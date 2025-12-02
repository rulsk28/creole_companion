import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/google_translate_service.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';

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

  Future<void> _translate() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() => _loading = true);

    final db = DatabaseHelper.instance;

    // LOCAL LOOKUP
    String? result = _englishToCreole
        ? await db.getCreole(input)
        : await db.getEnglish(input);

    // GOOGLE FALLBACK
    if (result == null) {
      result = await GoogleTranslateService.translate(
        text: input,
        from: _englishToCreole ? "en" : "ht",
        to: _englishToCreole ? "ht" : "en",
      );
      result ??= "No translation found.";
    }

    // SAVE HISTORY
    await db.saveHistory(
      input,
      result,
      _englishToCreole ? "EN → HT" : "HT → EN",
    );

    setState(() {
      _outputText = result!;
      _loading = false;
    });
  }

  Future<void> _saveFavorite() async {
    if (_outputText.isEmpty) return;

    await DatabaseHelper.instance.addFavorite(
      _inputController.text,
      _outputText,
      _englishToCreole ? "EN → HT" : "HT → EN",
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved to favorites")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creole Companion"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SWITCH EN/HT
            SwitchListTile(
              title: Text(
                _englishToCreole
                    ? "English → Haitian Creole"
                    : "Haitian Creole → English",
              ),
              value: _englishToCreole,
              onChanged: (v) => setState(() => _englishToCreole = v),
            ),

            // INPUT
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // TRANSLATE BUTTON
            ElevatedButton(
              onPressed: _loading ? null : _translate,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Translate"),
            ),

            const SizedBox(height: 20),

            // OUTPUT + FAVORITE BUTTON
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _outputText,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.star_border, size: 32),
                  onPressed: _saveFavorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
