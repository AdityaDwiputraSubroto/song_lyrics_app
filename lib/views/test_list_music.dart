import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:song_lyrics_app/views/detail_song.dart';
import 'package:song_lyrics_app/views/test_add_lyric.dart';
import '../controllers/song_controller.dart';
import '../models/song.dart';

class SongListScreenTest extends StatefulWidget {
  @override
  State<SongListScreenTest> createState() => _SongListScreenTestState();
}

class _SongListScreenTestState extends State<SongListScreenTest> {
  final SongController _songController = SongController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSongTestScreen()),
                );
              }),
          Expanded(
            child: FutureBuilder<List<Song?>?>(
              future: _songController.fetchAllSongs(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
