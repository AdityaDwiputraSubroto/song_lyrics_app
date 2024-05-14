import 'dart:convert';
import 'dart:io';

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
      conflictAlgorithm: ConflictAlgorithm.replace,
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
        imageName: maps[i]['imageName'],
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
        imageName: maps[i]['imageName'],
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
}
