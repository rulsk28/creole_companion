import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    sqfliteFfiInit(); // Initialize FFI for Windows/macOS/Linux
    var databaseFactory = databaseFactoryFfi;

    String dbPath = await databaseFactory.getDatabasesPath();
    String path = join(dbPath, 'creole_companion.db');

    _database = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE translations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            english TEXT,
            creole TEXT
          )
        ''');
        },
      ),
    );

    return _database!;
  }

  static Future<void> insertTranslation(String english, String creole) async {
    final db = await database;
    await db.insert('translations', {'english': english, 'creole': creole});
  }

  static Future<List<Map<String, dynamic>>> getTranslations() async {
    final db = await database;
    return await db.query('translations');
  }
}
