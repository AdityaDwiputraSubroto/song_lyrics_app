import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song_lyrics_app/controllers/song_controller.dart';
import 'package:song_lyrics_app/models/song.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  String? _newImagePath;
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = join(appDocDir.path, 'assets/songs');
      final String uniqueImageName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final String newImagePath = join(appDocPath, uniqueImageName);

      // Ensure the directory exists
      final Directory newDir = Directory(appDocPath);
      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
      }
      //final File newImage = await File(image.path).copy(newImagePath);

      setState(() {
        _newImagePath = newImagePath;
        _imagePath = image.path;
      });
    }
  }

  Future<void> _saveImage(String imagePath, String newImagePath) async {
    final File newImage = await File(imagePath).copy(newImagePath);
  }

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
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (_imagePath != null && _newImagePath != null) ...[
                SizedBox(height: 16.0),
                Text('Selected Image:'),
                Text('Path: $_imagePath'),
                Text('Name: $_newImagePath'),
              ],
              SizedBox(height: 16.0),
              if (_imagePath != null) ...[
                SizedBox(height: 16.0),
                Text('Selected Image:'),
                Image.file(File(_imagePath!)),
              ],
              ElevatedButton(
                onPressed: () {
                  final song = Song(
                    title: _titleController.text,
                    artist: _artistController.text,
                    lyrics: _lyricsController.text,
                    imageName: _newImagePath != null ? _newImagePath : null,
                    favorited: false, // Default to false
                  );
                  print(_lyricsController.text);

                  songController.addSong(
                      song, _imagePath != null ? _imagePath : '');
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
