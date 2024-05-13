import 'package:song_lyrics_app/models/login.dart';
import 'package:sqflite/sqflite.dart';
import 'dB.dart';

class AdminService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<LoginResponse?> verifyLogin(String username, String password) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'admin',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      final id = result.first['id'] as int;
      final username = result.first['username'] as String;
      print(result);
      return LoginResponse(id: id, username: username);
    }
    var databasesPath = await getDatabasesPath();
    print(databasesPath);

    return null;
  }
}
