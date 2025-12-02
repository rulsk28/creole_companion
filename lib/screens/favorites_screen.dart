import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, Object?>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final db = DatabaseHelper.instance;
    final result = await db.getFavorites();
    setState(() => _favorites = result);
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.removeFavorite(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: _favorites.isEmpty
          ? const Center(
              child: Text("No favorites yet.", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (_, i) {
                final f = _favorites[i];
                return ListTile(
                  title: Text("${f['input_text']} → ${f['output_text']}"),
                  subtitle: Text(f['direction'] as String),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(f['id'] as int),
                  ),
                );
              },
            ),
    );
  }
}
