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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Song?>?>(
                  future: _songController.fetchAllSongs(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Song? song = snapshot.data![index];
                          return ListTile(
                            leading: _buildSongImage(song),
                            title: Text(song!.title),
                            subtitle: Text(song.artist),
                            trailing: IconButton(
                              icon: Icon(
                                song.favorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: song.favorited ? Colors.red : null,
                              ),
                              onPressed: () {
                                _songController.toggleFavorite(
                                    song.id, !song.favorited);
                                setState(() {});
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailTestScreen(
                                          song: song,
                                        )),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            right: 30,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSongTestScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSongImage(Song? song) {
  if (song?.imageName != null) {
    final String imagePath = song!.imageName!;
    print('image name: ${song.imageName}');
    return Image.file(
      File(imagePath),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  } else {
    final String imagePath = 'assets/songs/music-default.png';
    print('image name: ${song!.imageName}');
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }
}
