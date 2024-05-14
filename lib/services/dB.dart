import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'lyrics_app_test1.db';
  static const String adminTable = 'admin';
  static const String songsTable = 'songs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<void> deleteDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    await deleteDatabase(path);
    print('delete success');
  }

  Future<bool> checkDatabaseExists() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    return databaseExists(path);
  }

  Future<Database> initDatabase() async {
    if (await checkDatabaseExists()) {
      print('Database already exists');
      return openDatabase(
        join(await getDatabasesPath(), dbName),
      );
    } else {
      return openDatabase(
        join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $adminTable(
            id INTEGER PRIMARY KEY,
            username TEXT,
            password TEXT
          )
        ''');

          await db.execute('''
          CREATE TABLE $songsTable(
            id INTEGER PRIMARY KEY,
            title TEXT,
            artist TEXT,
            lyrics TEXT,
            imageName TEXT,
            favorited INTEGER
          )
        ''');

          // Insert initial admin data
          await db.rawInsert('''
          INSERT INTO $adminTable(username, password)
          VALUES('admin', 'admin123')
        ''');
        },
        version: 1,
      );
    }
  }
}
