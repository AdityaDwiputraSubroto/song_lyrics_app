import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:song_lyrics_app/controllers/song_controller.dart';
import 'package:song_lyrics_app/models/song.dart';

class AddSongTestScreen extends StatefulWidget {
  @override
  _AddSongTestScreenState createState() => _AddSongTestScreenState();
}

class _AddSongTestScreenState extends State<AddSongTestScreen> {
  final SongController songController = SongController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _lyricsController =
      TextEditingController(text: 'add \n add');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Song')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _artistController,
                decoration: InputDecoration(labelText: 'Artist'),
              ),
              TextField(
                controller: _lyricsController,
                decoration: InputDecoration(labelText: 'Lyrics'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              ElevatedButton(
                onPressed: () async {
                  String? lyrics = await songController.fetchLyrics(
                      context,
                      _artistController.text.trim(),
                      _titleController.text.trim());
                  if (lyrics != null) {
                    setState(() {
                      _lyricsController.text = lyrics;
                    });
                  }
                },
                child: Text('Fetch Lyrics'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final song = Song(
                    title: _titleController.text,
                    artist: _artistController.text,
                    lyrics: _lyricsController.text,
                    favorited: false, // Default to false
                  );
                  print(_lyricsController.text);

                  songController.addSong(song);
                  //Navigator.pop(context);
                },
                child: Text('Add Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Replace \n with newline and \t with tab
    String newText =
        newValue.text.replaceAll('\n', '\\n').replaceAll('\t', '\\t');
    return newValue.copyWith(text: newText);
  }
}
