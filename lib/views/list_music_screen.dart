import 'dart:io';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/views/detail_song.dart';
import 'package:song_lyrics_app/views/add_lyrics_screen.dart';
import '../controllers/song_controller.dart';
import '../models/song.dart';

class SongListScreen extends StatefulWidget {
  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final SongController _songController = SongController();
  List<Song?> _allSongs = [];
  List<Song?> _filteredSongs = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSongs);
    _fetchSongs();
  }

  void _fetchSongs() async {
    final songs = await _songController.fetchAllSongs(context);
    setState(() {
      _allSongs = songs!;
      _filteredSongs = _allSongs;
    });
  }

  void _filterSongs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _allSongs;
      } else {
        _filteredSongs = _allSongs
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
                'Daftar List',
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
          itemCount: _filteredSongs.length,
          itemBuilder: (context, index) {
            Song? song = _filteredSongs[index];
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFb2855d),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSongTestScreen()),
          );
        },
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
      final index = _filteredSongs.indexWhere((song) => song!.id == songId);
      if (index != -1) {
        _filteredSongs[index]!.favorited = isFavorite;
      }
    });
  }
}
