import 'dart:io';

import 'package:flutter/material.dart';
import 'package:song_lyrics_app/views/detail_song.dart';
import '../controllers/song_controller.dart';
import '../models/song.dart';

class FavoriteListScreenTest extends StatefulWidget {
  @override
  State<FavoriteListScreenTest> createState() => _FavoriteListScreenTestState();
}

class _FavoriteListScreenTestState extends State<FavoriteListScreenTest> {
  final SongController _songController = SongController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: FutureBuilder<List<Song?>?>(
        future: _songController.fetchAllFavorites(context),
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
                      song.favorited ? Icons.favorite : Icons.favorite_border,
                      color: song.favorited ? Colors.red : null,
                    ),
                    onPressed: () {
                      _songController.toggleFavorite(song.id, !song.favorited);
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
