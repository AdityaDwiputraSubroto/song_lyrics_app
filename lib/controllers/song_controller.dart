import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/models/song.dart';
import 'package:song_lyrics_app/services/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/services/song_service.dart';
import 'package:http/http.dart' as http;

class SongController {
  final SongService _songService = SongService();

  Future<void> addSong(Song song) async {
    try {
      _songService.insertSong(song);
      print('add song success');
    } catch (e) {
      print('add song error : $e');
    }
  }

  Future<String?> fetchLyrics(
      BuildContext context, String artist, String title) async {
    if (artist.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lyrics not found')),
      );
      return null;
    }

    try {
      String? lyrics = await _songService.getLyrics(artist, title);
      print(lyrics);
      return lyrics;
    } catch (e) {
      print('Error fetching lyrics: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e}')),
      );
    }
  }

  Future<List<Song?>?> fetchAllSongs(BuildContext context) async {
    try {
      return await _songService.getAllSongs();
    } catch (e) {
      print('Error fetching lyrics: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e}')),
      );
    }
  }

  Future<void> toggleFavorite(int? songId, bool isFavorited) async {
    try {
      await _songService.toggleFavorite(songId!, isFavorited);
      print("toggle favorite success : $isFavorited");
    } catch (e) {
      print('Error toggle favorite: $e');
    }
  }
}
