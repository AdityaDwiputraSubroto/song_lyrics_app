import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/models/song.dart';
import 'package:song_lyrics_app/services/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/services/song_service.dart';
import 'package:http/http.dart' as http;
import 'package:song_lyrics_app/views/list_music_screen.dart';

class SongController {
  final SongService _songService = SongService();

  Future<void> addSong(
      BuildContext context, Song song, String? imagePath) async {
    try {
      _songService.insertSong(song);
      if (imagePath != null && song.imageName != null) {
        _songService.saveImage(imagePath, song.imageName!);
      }
      print(song.imageName);
      print('add song success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return SongListScreen();
        }),
      );
    } catch (e) {
      print('add song error : $e');
    }
  }

  Future<void> _saveImage(String imagePath, String newImagePath) async {
    final File newImage = await File(imagePath).copy(newImagePath);
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

  Future<List<Song?>?> fetchAllFavorites(BuildContext context) async {
    try {
      return await _songService.getAllFavorites();
    } catch (e) {
      print('Error fetching Favorites: $e');
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
