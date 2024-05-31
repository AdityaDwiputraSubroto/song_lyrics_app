import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:song_lyrics_app/models/login.dart';
import 'package:song_lyrics_app/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dB.dart';

class SongService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertSong(Song song) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.songsTable,
      song.toMap(),
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSong(Song song) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.songsTable,
      song.toMap(),
      where: 'id = ?', whereArgs: [song.id],
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSong(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.songsTable,
      where: 'id = ?', whereArgs: [id],
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLyrics(String artist, String title) async {
    String apiUrl = 'https://api.lyrics.ovh/v1/$artist/$title';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      String lyrics = jsonData['lyrics'];
      return lyrics;
    } else {
      throw Exception('Lyrics not found');
    }
  }

  Future<List<Song?>> getAllSongs() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.songsTable);
    return List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
        title: maps[i]['title'],
        artist: maps[i]['artist'],
        lyrics: maps[i]['lyrics'],
        imagePath: maps[i]['imageName'],
        favorited: maps[i]['favorited'] == 1,
      );
    });
  }

  Future<List<Song?>> getAllFavorites() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.songsTable,
      where: 'favorited = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
        title: maps[i]['title'],
        artist: maps[i]['artist'],
        lyrics: maps[i]['lyrics'],
        imagePath: maps[i]['imageName'],
        favorited: maps[i]['favorited'] == 1,
      );
    });
  }

  Future<void> toggleFavorite(int songId, bool isFavorited) async {
    final db = await _dbHelper.database;
    await db.update(
      'songs',
      {'favorited': isFavorited ? 1 : 0},
      where: 'id = ?',
      whereArgs: [songId],
    );
  }

  Future<void> saveImage(String imagePath, String newImagePath) async {
    final File newImage = await File(imagePath).copy(newImagePath);
  }

  Future<String> createImagePath(String imageName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = join(appDocDir.path, 'assets/songs');
    final String uniqueImageName =
        '${DateTime.now().millisecondsSinceEpoch}_${imageName}';
    final String newImagePath = join(appDocPath, uniqueImageName);
    final Directory newDir = Directory(appDocPath);

    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }

    return newImagePath;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      // Create a File instance with the provided path
      File imageFile = File(imagePath);

      if (await imageFile.exists()) {
        await imageFile.delete();
        print('Image deleted successfully.');
      } else {
        print('Image does not exist at the provided path.');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
