import 'package:song_lyrics_app/services/song_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'lyrics_app_test13.db';
  static const String adminTable = 'admin';
  static const String songsTable = 'songs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    initialSongs();
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

  Future<void> initialSongs() async {
    //   // Insert initial admin data
    List<Map<String, dynamic>> initialSongs = [
      {
        'title': '7 rings',
        'artist': 'ariana grande',
        'lyrics': '',
        'favorited': 0
      },
      {
        'title': '7 years',
        'artist': 'lukas graham',
        'lyrics': '',
        'favorited': 0
      },
      {
        'title': 'west coast',
        'artist': 'one republic',
        'lyrics': '',
        'favorited': 0
      },
      {'title': 'without me', 'artist': 'halsey', 'lyrics': '', 'favorited': 0},
      {'title': 'numb', 'artist': 'linkin park', 'lyrics': '', 'favorited': 0},
      {
        'title': 'goosebumps',
        'artist': 'travis scott',
        'lyrics': '',
        'favorited': 0
      },
      {'title': 'cradles', 'artist': 'sub urban', 'lyrics': '', 'favorited': 0},
      {
        'title': 'light switch',
        'artist': 'charlie puth',
        'lyrics': '',
        'favorited': 0
      },
      {
        'title': 'ghost',
        'artist': 'justin bieber',
        'lyrics': '',
        'favorited': 0
      },
      {'title': 'water', 'artist': 'tyla', 'lyrics': '', 'favorited': 0},
      {'title': 'rude', 'artist': 'magic', 'lyrics': '', 'favorited': 0},
      {
        'title': 'chasing shadows',
        'artist': 'alex warren',
        'lyrics': '',
        'favorited': 0
      },
      {'title': 'solo', 'artist': 'myles smith', 'lyrics': '', 'favorited': 0},
    ];
    SongService _songService = SongService();
    for (var song in initialSongs) {
      try {
        song['lyrics'] =
            await _songService.getLyrics(song['artist']!, song['title']!);
      } catch (e) {
        print('${song['title']} : $e');
        song['lyrics'] = '';
      }

      await _database?.insert(
        DatabaseHelper.songsTable,
        song,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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

          //   // Insert initial admin data
          //   await db.rawInsert('''
          //   INSERT INTO $adminTable(username, password)
          //   VALUES('admin', 'admin123')
          // ''');
        },
        version: 1,
      );
    }
  }
}
