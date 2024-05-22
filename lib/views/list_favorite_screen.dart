import 'dart:io';

import 'package:flutter/material.dart';
import 'package:song_lyrics_app/views/detail_song.dart';
import '../controllers/song_controller.dart';
import '../models/song.dart';

class FavoriteListScreen extends StatefulWidget {
  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  final SongController _songController = SongController();
  List<Song?> _favoriteSongs = [];
  List<Song?> _filteredFavoriteSongs = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSongs);
    _fetchFavorites();
  }

  void _fetchFavorites() async {
    final favorites = await _songController.fetchAllFavorites(context);
    setState(() {
      _favoriteSongs = favorites!;
      _filteredFavoriteSongs = _favoriteSongs;
    });
  }

  void _filterSongs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFavoriteSongs = _favoriteSongs;
      } else {
        _filteredFavoriteSongs = _favoriteSongs
            .where((song) =>
                song!.title.toLowerCase().contains(query) ||
                song.artist.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe7c197),
      appBar: AppBar(
        backgroundColor: Color(0xFFb2855d),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search songs...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF0b0302)),
                ),
                style: TextStyle(color: Color(0xFF0b0302), fontSize: 18),
              )
            : Text(
                'Favorite List',
                style: TextStyle(
                  color: Color(0xFF0b0302),
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: Color(0xFF0b0302)),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: _filteredFavoriteSongs.length,
          itemBuilder: (context, index) {
            Song? song = _filteredFavoriteSongs[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFb5875f)),
                ),
                elevation: 5,
                shadowColor: Color(0xFFb5875f),
                child: ListTile(
                  leading: _buildSongImage(song),
                  title: Text(
                    song!.title,
                    style: TextStyle(color: Color(0xFF0b0302)),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(color: Color(0xFF0b0302)),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      song.favorited ? Icons.favorite : Icons.favorite_border,
                      color: song.favorited ? Colors.red : null,
                    ),
                    onPressed: () async {
                      await _toggleFavorite(song.id, !song.favorited);
                      _fetchFavorites(); // Fetch favorites after toggling
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTestScreen(song: song),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongImage(Song? song) {
    if (song?.imageName != null) {
      final String imagePath = song!.imageName!;
      return Image.file(
        File(imagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      final String imagePath = 'assets/songs/music-default.png';
      return Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _toggleFavorite(int? songId, bool isFavorite) async {
    await _songController.toggleFavorite(songId, isFavorite);
    setState(() {
      final index = _favoriteSongs.indexWhere((song) => song!.id == songId);
      if (index != -1) {
        _favoriteSongs[index]!.favorited = isFavorite;
      }
    });
  }
}
