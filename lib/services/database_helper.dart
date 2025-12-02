import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    final Directory dir = await getApplicationDocumentsDirectory();
    final String dbPath = join(dir.path, "creole_companion.db");

    _db = sqlite3.open(dbPath);
    _createTables(_db!);
    return _db!;
  }

  // ---------------------------------------------
  // CREATE TABLES
  // ---------------------------------------------
  void _createTables(Database db) {
    db.execute("""
      CREATE TABLE IF NOT EXISTS translations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        english TEXT NOT NULL,
        creole TEXT NOT NULL
      );
    """);

    db.execute("""
      CREATE TABLE IF NOT EXISTS history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        input_text TEXT NOT NULL,
        output_text TEXT NOT NULL,
        direction TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    """);

    db.execute("""
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        input_text TEXT NOT NULL,
        output_text TEXT NOT NULL,
        direction TEXT NOT NULL
      );
    """);

    final count = db
        .select("SELECT COUNT(*) AS c FROM translations")
        .first['c'];

    if (count == 0) {
      _insertDefaults(db);
    }
  }

  // ---------------------------------------------
  // INSERT DEFAULT 100 TRANSLATIONS
  // ---------------------------------------------
  void _insertDefaults(Database db) {
    final stmt = db.prepare(
      "INSERT INTO translations (english, creole) VALUES (?, ?)",
    );

    final translations = [
      ["Hello", "Bonjou"],
      ["Hi", "Sak pase"],
      ["Good morning", "Bonjou"],
      ["Good afternoon", "Bonswa"],
      ["Good evening", "Bonswa"],
      ["Good night", "Bon nwit"],
      ["Thank you", "Mèsi"],
      ["Thank you very much", "Mèsi anpil"],
      ["Please", "Tanpri"],
      ["Yes", "Wi"],
      ["No", "Non"],
      ["Maybe", "Petèt"],
      ["Excuse me", "Eskize m"],
      ["Sorry", "Mwen regrèt"],
      ["How are you?", "Kijan ou ye?"],
      ["I'm fine", "Mwen byen"],
      ["See you later", "Na wè pita"],
      ["See you tomorrow", "Na wè demen"],
      ["I love you", "Mwen renmen ou"],
      ["I miss you", "Ou manke mwen"],
      ["Where are you from?", "Ou soti ki kote?"],
      ["I am from Haiti", "Mwen soti Ayiti"],
      ["Where do you live?", "Ki kote ou rete?"],
      ["I live in New Jersey", "Mwen rete New Jersey"],
      ["I am hungry", "Mwen grangou"],
      ["I am thirsty", "Mwen swaf"],
      ["I am tired", "Mwen fatige"],
      ["I understand", "Mwen konprann"],
      ["I don't understand", "Mwen pa konprann"],
      ["Help me", "Ede m"],
      ["Where is the bathroom?", "Kote twalèt la?"],
      ["Where is the hospital?", "Kote lopital la?"],
      ["Call the police", "Rele lapolis"],
      ["Stop", "Sispann"],
      ["Come here", "Vin isi"],
      ["Go there", "Ale la"],
      ["What time is it?", "Kilè li ye?"],
      ["How much is this?", "Konbyen sa koute?"],
      ["I need water", "Mwen bezwen dlo"],
      ["I'm sick", "Mwen malad"],
      ["I'm happy", "Mwen kontan"],
      ["I'm sad", "Mwen tris"],
      ["Good luck", "Bon chans"],
      ["Be careful", "Pran prekosyon"],
      ["Congratulations", "Felisitasyon"],
    ];

    for (var row in translations) {
      stmt.execute(row);
    }
    stmt.dispose();
  }

  // ---------------------------------------------
  // LOCAL TRANSLATION LOOKUP
  // ---------------------------------------------
  Future<String?> getCreole(String english) async {
    final db = await database;
    final res = db.select(
      "SELECT creole FROM translations WHERE LOWER(english)=LOWER(?) LIMIT 1",
      [english.trim()],
    );
    return res.isEmpty ? null : res.first['creole'] as String;
  }

  Future<String?> getEnglish(String creole) async {
    final db = await database;
    final res = db.select(
      "SELECT english FROM translations WHERE LOWER(creole)=LOWER(?) LIMIT 1",
      [creole.trim()],
    );
    return res.isEmpty ? null : res.first['english'] as String;
  }

  // ---------------------------------------------
  // HISTORY
  // ---------------------------------------------
  Future<void> saveHistory(
    String input,
    String output,
    String direction,
  ) async {
    final db = await database;
    final time = DateTime.now().toLocal().toString().split(".").first;

    db.execute(
      "INSERT INTO history (input_text, output_text, direction, timestamp) VALUES (?, ?, ?, ?)",
      [input, output, direction, time],
    );
  }

  Future<List<Map<String, Object?>>> getHistory() async {
    final db = await database;
    final rows = db.select("SELECT * FROM history ORDER BY id DESC");
    return rows.map((e) => e).toList();
  }

  // ---------------------------------------------
  // FAVORITES
  // ---------------------------------------------
  Future<void> addFavorite(
    String input,
    String output,
    String direction,
  ) async {
    final db = await database;
    db.execute(
      "INSERT INTO favorites (input_text, output_text, direction) VALUES (?, ?, ?)",
      [input, output, direction],
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    db.execute("DELETE FROM favorites WHERE id=?", [id]);
  }

  Future<List<Map<String, Object?>>> getFavorites() async {
    final db = await database;
    final rows = db.select("SELECT * FROM favorites ORDER BY id DESC");
    return rows.map((e) => e).toList();
  }
}
