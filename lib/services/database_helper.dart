import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit(); // Needed for desktop
    final dbPath = await databaseFactoryFfi.getDatabasesPath();
    final path = p.join(dbPath, 'translations.db');

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDB),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE translations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        english TEXT NOT NULL,
        creole TEXT NOT NULL
      )
    ''');

    // ✅ Add your custom Creole translations here
    await db.insert('translations', {
      'english': 'Good morning',
      'creole': 'bonjou',
    });
    await db.insert('translations', {'english': 'thank you', 'creole': 'mesi'});
    await db.insert('translations', {'english': 'goodbye', 'creole': 'orevwa'});
    await db.insert('translations', {'english': 'please', 'creole': 'souple'});
    await db.insert('translations', {
      'english': 'how are you',
      'creole': 'kijanw ye',
    });
    await db.insert('translations', {
      'english': 'My name is',
      'creole': 'Mwen rele',
    });
    await db.insert('translations', {
      'english': 'My app is almost done',
      'creole': 'App la preske fini',
    });
  }

  /// ✅ Function to get a Creole translation for an English word
  Future<String?> getCreoleTranslation(String englishWord) async {
    final db = await database;
    final result = await db.query(
      'translations',
      where: 'english = ?',
      whereArgs: [englishWord.toLowerCase()],
    );

    if (result.isNotEmpty) {
      return result.first['creole'] as String;
    } else {
      return null;
    }
  }

  /// ✅ (Optional) Function to add new translations manually later
  Future<void> insertTranslation(String english, String creole) async {
    final db = await database;
    await db.insert('translations', {
      'english': english.toLowerCase(),
      'creole': creole.toLowerCase(),
    });
  }
}
