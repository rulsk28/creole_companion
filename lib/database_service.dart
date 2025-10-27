import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseService {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialize FFI (needed for Windows and desktop apps)
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;

    // Define the path where the database will be stored
    final dbPath = join(Directory.current.path, 'creole_companion.db');

    // Open or create the database
    _database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // Create your translations table
          await db.execute('''
            CREATE TABLE translations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              english TEXT,
              creole TEXT
            )
          ''');
        },
      ),
    );

    print('✅ Database initialized at $dbPath');
    return _database!;
  }
}
