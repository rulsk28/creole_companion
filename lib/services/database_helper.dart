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

    final count = db
        .select("SELECT COUNT(*) AS c FROM translations")
        .first['c'];
    if (count == 0) {
      _insertDefaults(db);
    }
  }

 
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
      ["How are you?", "Kijan ou ye?"],
      ["What is your name?", "Kijan ou rele?"],
      ["My name is John", "Non mwen se John"],
      ["Nice to meet you", "Mwen kontan fè konesans avè w"],
      ["Thank you", "Mèsi"],
      ["Thank you very much", "Mèsi anpil"],
      ["You are welcome", "Pa gen pwoblèm"],
      ["Please", "Tanpri"],
      ["Excuse me", "Eskize m"],
      ["I am sorry", "Mwen regrèt"],
      ["Yes", "Wi"],
      ["No", "Non"],
      ["Maybe", "Petèt"],
      ["I do not understand", "Mwen pa konprann"],
      ["I understand", "Mwen konprann"],
      ["Do you speak English?", "Eske ou pale Anglè?"],
      ["Do you speak Creole?", "Eske ou pale Kreyòl?"],
      ["I speak a little Creole", "Mwen pale yon ti kras Kreyòl"],
      ["I am learning Creole", "Mwen ap aprann Kreyòl"],
      ["Where are you from?", "Ou soti ki kote?"],
      ["I am from Haiti", "Mwen soti Ayiti"],
      ["Where do you live?", "Ki kote ou rete?"],
      ["I live in New Jersey", "Mwen rete New Jersey"],
      ["How old are you?", "Ki laj ou?"],
      ["I am hungry", "Mwen grangou"],
      ["I am thirsty", "Mwen swaf"],
      ["I am tired", "Mwen fatige"],
      ["I am sick", "Mwen malad"],
      ["I am happy", "Mwen kontan"],
      ["I am sad", "Mwen tris"],
      ["I love you", "Mwen renmen ou"],
      ["I miss you", "Ou manke mwen"],
      ["See you later", "Na wè pita"],
      ["See you tomorrow", "Na wè demen"],
      ["Good luck", "Bon chans"],
      ["Be careful", "Pran prekosyon"],
      ["What time is it?", "Kilè li ye?"],
      ["Where is the bathroom?", "Kote twalèt la?"],
      ["Where is the hospital?", "Kote lopital la?"],
      ["Call the police", "Rele lapolis"],
      ["I need help", "Mwen bezwen èd"],
      ["I need water", "Mwen bezwen dlo"],
      ["Stop", "Sispann"],
      ["Go", "Ale"],
      ["Wait", "Tann"],
      ["Come here", "Vini isit la"],
      ["Where are you?", "Kote ou ye?"],
      ["I am coming", "Mwen prale"],
      ["I don’t know", "Mwen pa konnen"],
      ["I know", "Mwen konnen"],
      ["What happened?", "Kisa ki pase?"],
      ["I’m on my way", "Mwen sou wout la"],
      ["Help me please", "Ede m tanpri"],
      ["It hurts", "Sa fè m mal"],
      ["How much is it?", "Konbyen li koute?"],
      ["Too expensive", "Twò chè"],
      ["Do you have food?", "Eske ou gen manje?"],
      ["I am lost", "Mwen pèdi"],
      ["I need a doctor", "Mwen bezwen yon doktè"],
      ["Call my family", "Rele fanmi mwen"],
      ["Be quiet", "Fè silans"],
      ["Stop talking", "Sispann pale"],
      ["Open the door", "Louvri pòt la"],
      ["Close the door", "Fèmen pòt la"],
      ["I am outside", "Mwen deyò"],
      ["I am inside", "Mwen andedan"],
      ["Come inside", "Antre"],
      ["Go outside", "Soti deyò"],
      ["I’m ready", "Mwen pare"],
      ["Not yet", "Pa ankò"],
      ["I agree", "Mwen dakò"],
      ["I disagree", "Mwen pa dakò"],
      ["What do you want?", "Kisa ou vle?"],
      ["I want food", "Mwen vle manje"],
      ["I want water", "Mwen vle dlo"],
    ];

    for (var t in translations) {
      stmt.execute(t);
    }
    stmt.dispose();
  }

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

  Future<void> saveHistory(
    String input,
    String output,
    String direction,
  ) async {
    final db = await database;
    final now = DateTime.now().toLocal().toString().split('.').first;

    db.execute(
      "INSERT INTO history (input_text, output_text, direction, timestamp) VALUES (?, ?, ?, ?)",
      [input, output, direction, now],
    );
  }

  Future<List<Map<String, Object?>>> getHistory() async {
    final db = await database;
    final rows = db.select("SELECT * FROM history ORDER BY id DESC");
    return rows.map((e) => e).toList();
  }

  Future<List<Map<String, Object?>>> getFavorites() async {
    final db = await database;
    final rows = db.select(
      "SELECT english, creole FROM translations ORDER BY english ASC",
    );
    return rows.map((r) => r).toList();
  }
}
