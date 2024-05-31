import 'dart:io';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/views/screens/detail_song.dart';
import 'package:song_lyrics_app/views/screens/add_lyrics_screen.dart';
import 'package:song_lyrics_app/views/screens/edit_lyrics_screen.dart';
import '../../controllers/song_controller.dart';
import '../../models/song.dart';

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

  Future<void> _fetchSongs() async {
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          song.favorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: song.favorited ? Colors.red : null,
                        ),
                        onPressed: () async {
                          await _toggleFavorite(song.id, !song.favorited);
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String result) async {
                          switch (result) {
                            case 'edit':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditSongScreen(song: song),
                                ),
                              );
                              break;
                            case 'delete':
                              _showDeleteConfirmationDialog(song);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(song: song),
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
            MaterialPageRoute(builder: (context) => AddSongScreen()),
          );
        },
      ),
    );
  }

  Widget _buildSongImage(Song? song) {
    if (song?.imagePath != null) {
      final String imagePath = song!.imagePath!;
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
      final index = _allSongs.indexWhere((song) => song!.id == songId);
      if (index != -1) {
        _allSongs[index]!.favorited = isFavorite;
      }
      //_filterSongs();
    });
  }

  Future<dynamic> _showDeleteConfirmationDialog(Song song) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Song'),
          content: Text('Are you sure you want to delete this song?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFb2855d)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () async {
                await _deleteSong(song);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSong(Song song) async {
    await _songController.deleteSong(song);
    setState(() {
      _allSongs.removeWhere((s) => s!.id == song.id);
      _filteredSongs.removeWhere((s) => s!.id == song.id);
    });
  }
}
