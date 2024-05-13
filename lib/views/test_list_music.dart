import 'package:flutter/material.dart';

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
      body: FutureBuilder<List<Song?>?>(
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
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
    );
  }
}
