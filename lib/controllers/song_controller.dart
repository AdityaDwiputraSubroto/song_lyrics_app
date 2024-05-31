import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/models/song.dart';
import 'package:song_lyrics_app/services/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/services/song_service.dart';
import 'package:http/http.dart' as http;
import 'package:song_lyrics_app/views/screens/bottom_navbar.dart';
import 'package:song_lyrics_app/views/screens/list_music_screen.dart';

class SongController {
  final SongService _songService = SongService();

  Future<void> addSong(
      BuildContext context, Song song, String? imageName) async {
    try {
      if (song.imagePath != null && imageName != null) {
        String newImagePath = await _songService.createImagePath(imageName);
        _songService.saveImage(song.imagePath!, newImagePath);
        song.imagePath = newImagePath;
      }
      _songService.insertSong(song);

      print(song.imagePath);
      print('Add song success');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add song error : $e')),
      );
      print('Add song error : $e');
    }
  }

  Future<void> editSong(
    BuildContext context,
    Song song,
    String? imageName,
  ) async {
    try {
      if (song.imagePath != null && imageName != null) {
        String newImagePath = await _songService.createImagePath(imageName);
        _songService.saveImage(song.imagePath!, newImagePath);
        _songService.deleteImage(song.imagePath!);
        song.imagePath = newImagePath;
      }
      _songService.updateSong(song);

      print(song.imagePath);
      print('edit song success');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edit song error : $e')),
      );
      print('Edit song error : $e');
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

  Future<void> deleteSong(Song song) async {
    try {
      if (song.id == null) {
        throw ("Id is null");
      }
      await _songService.deleteSong(song.id!);

      if (song.imagePath != null) {
        _songService.deleteImage(song.imagePath!);
      }

      print("Delete song Success");
    } catch (e) {
      print("Delete failed : $e");
    }
  }
}
