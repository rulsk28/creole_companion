import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'translations.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE translations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        english TEXT NOT NULL,
        creole TEXT NOT NULL
      )
    ''');

    List<Map<String, String>> translations = [
      {'english': 'Hello', 'creole': 'Bonjou'},
      {'english': 'Good morning', 'creole': 'Bonjou'},
      {'english': 'Good night', 'creole': 'Bon nwit'},
      {'english': 'How are you?', 'creole': 'Kijan ou ye?'},
      {'english': 'I am fine', 'creole': 'Mwen byen'},
      {'english': 'What is your name?', 'creole': 'Kijan ou rele?'},
      {'english': 'My name is', 'creole': 'Non mwen se'},
      {'english': 'Where are you from?', 'creole': 'Ki kote ou sòti?'},
      {'english': 'I am from Haiti', 'creole': 'Mwen sòti Ayiti'},
      {'english': 'Thank you', 'creole': 'Mèsi'},
      {'english': 'You are welcome', 'creole': 'Pa gen pwoblèm'},
      {'english': 'Please', 'creole': 'Silvouplè'},
      {'english': 'Excuse me', 'creole': 'Eskize m'},
      {'english': 'Yes', 'creole': 'Wi'},
      {'english': 'No', 'creole': 'Non'},
      {'english': 'Maybe', 'creole': 'Pètèt'},
      {'english': 'I love you', 'creole': 'Mwen renmen ou'},
      {'english': 'I miss you', 'creole': 'Mwen sonje ou'},
      {'english': 'Goodbye', 'creole': 'Orevwa'},
      {'english': 'See you later', 'creole': 'N a wè pita'},
      {'english': 'Be careful', 'creole': 'Pridan'},
      {'english': 'Good luck', 'creole': 'Bon chans'},
      {'english': 'I need help', 'creole': 'Mwen bezwen èd'},
      {'english': 'Can you help me?', 'creole': 'Èske ou ka ede m?'},
      {'english': 'I don’t understand', 'creole': 'Mwen pa konprann'},
      {'english': 'Can you repeat?', 'creole': 'Èske ou ka repete?'},
      {'english': 'Where is the bathroom?', 'creole': 'Kote twalèt la?'},
      {'english': 'How much is it?', 'creole': 'Konbyen li koute?'},
      {'english': 'I am hungry', 'creole': 'Mwen grangou'},
      {'english': 'I am thirsty', 'creole': 'Mwen swaf'},
      {'english': 'I am tired', 'creole': 'Mwen fatige'},
      {'english': 'I am sick', 'creole': 'Mwen malad'},
      {'english': 'Call a doctor', 'creole': 'Rele yon doktè'},
      {'english': 'Call the police', 'creole': 'Rele lapolis'},
      {'english': 'Where do you live?', 'creole': 'Ki kote ou rete?'},
      {'english': 'I live in New Jersey', 'creole': 'Mwen rete New Jersey'},
      {'english': 'It’s hot today', 'creole': 'Li fè cho jodi a'},
      {'english': 'It’s cold today', 'creole': 'Li fè frèt jodi a'},
      {'english': 'Let’s go', 'creole': 'Ann ale'},
      {'english': 'Stop', 'creole': 'Sispann'},
      {'english': 'Come here', 'creole': 'Vini isit la'},
      {'english': 'Sit down', 'creole': 'Chita'},
      {'english': 'Stand up', 'creole': 'Kanpe'},
      {'english': 'Wait a moment', 'creole': 'Tann yon ti moman'},
      {'english': 'I don’t know', 'creole': 'Mwen pa konnen'},
      {'english': 'I forgot', 'creole': 'Mwen bliye'},
      {'english': 'That’s funny', 'creole': 'Sa komik'},
      {'english': 'I’m sorry', 'creole': 'Mwen dezole'},
      {'english': 'I need water', 'creole': 'Mwen bezwen dlo'},
      {'english': 'Do you speak English?', 'creole': 'Èske ou pale Anglè?'},
      {
        'english': 'I speak a little Creole',
        'creole': 'Mwen pale yon ti kras Kreyòl',
      },
      {'english': 'I’m learning Creole', 'creole': 'Mwen ap aprann Kreyòl'},
      {'english': 'What time is it?', 'creole': 'Ki lè li ye?'},
      {'english': 'Where are we going?', 'creole': 'Ki kote nou prale?'},
      {'english': 'What happened?', 'creole': 'Kisa k pase?'},
      {'english': 'I am happy', 'creole': 'Mwen kontan'},
      {'english': 'I am sad', 'creole': 'Mwen tris'},
      {'english': 'See you tomorrow', 'creole': 'N a wè demen'},
      {'english': 'Take care', 'creole': 'Pran swen tèt ou'},
      {'english': 'Nice to meet you', 'creole': 'Mwen kontan rankontre ou'},
      {'english': 'Welcome', 'creole': 'Byenvini'},
      {'english': 'Where is the hotel?', 'creole': 'Kote otèl la?'},
      {'english': 'Where is the airport?', 'creole': 'Kote ayewopò a?'},
      {'english': 'Where is the market?', 'creole': 'Kote mache a?'},
      {'english': 'I am lost', 'creole': 'Mwen pèdi'},
      {'english': 'Can I have the menu?', 'creole': 'Mwen ka gen meni an?'},
      {'english': 'I want rice', 'creole': 'Mwen vle diri'},
      {'english': 'I want chicken', 'creole': 'Mwen vle mange poul'},
      {'english': 'I’m full', 'creole': 'vant Mwen plen'},
      {'english': 'Delicious', 'creole': 'li gou'},
      {'english': 'Where is the beach?', 'creole': 'Kote plaj la?'},
      {'english': 'Where is the bank?', 'creole': 'Kote bank la?'},
      {'english': 'I don’t have money', 'creole': 'Mwen pa gen lajan'},
      {
        'english': 'Can I use your phone?',
        'creole': 'Mwen ka itilize telefòn ou an?',
      },
      {
        'english': 'What’s your phone number?',
        'creole': 'Ki nimewo telefòn ou?',
      },
      {'english': 'I’m going home', 'creole': 'Mwen prale lakay mwen'},
      {'english': 'See you soon', 'creole': 'Nap wè talè'},
    ];

    for (var t in translations) {
      await db.insert('translations', t);
    }
  }

  Future<String?> getCreoleTranslation(String englishText) async {
    Database db = await instance.database;
    var result = await db.query(
      'translations',
      where: 'LOWER(english) = LOWER(?)',
      whereArgs: [englishText.toLowerCase()],
    );
    if (result.isNotEmpty) {
      return result.first['creole'] as String?;
    }
    return null;
  }

  Future<String?> getEnglishTranslation(String creoleText) async {
    Database db = await instance.database;
    var result = await db.query(
      'translations',
      where: 'LOWER(creole) = LOWER(?)',
      whereArgs: [creoleText.toLowerCase()],
    );
    if (result.isNotEmpty) {
      return result.first['english'] as String?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllTranslations() async {
    Database db = await instance.database;
    return await db.query('translations');
  }

  Future<void> clearDatabase() async {
    Database db = await instance.database;
    await db.delete('translations');
  }
}
