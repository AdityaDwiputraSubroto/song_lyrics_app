import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:song_lyrics_app/controllers/song_controller.dart';
import 'package:song_lyrics_app/models/song.dart';

class AddSongTestScreen extends StatefulWidget {
  @override
  _AddSongTestScreenState createState() => _AddSongTestScreenState();
}

class _AddSongTestScreenState extends State<AddSongTestScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SongController songController = SongController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
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
      appBar: AppBar(
        title: Text('Add New Song'),
        backgroundColor: Color(0xFFb2855d),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/logo.png',
              height: 40,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFe7c197),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Color(0xFFb2855d)),
                            borderRadius: BorderRadius.circular(
                                6.0), // Menambahkan border radius
                          ),
                          child: _imagePath != null
                              ? Image.file(File(_imagePath!))
                              : Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title Song',
                      labelStyle: TextStyle(color: Color(0xFF0b0302)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    style: TextStyle(color: Color(0xFF0b0302)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _artistController,
                    decoration: InputDecoration(
                      labelText: 'Artist',
                      labelStyle: TextStyle(color: Color(0xFF0b0302)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    style: TextStyle(color: Color(0xFF0b0302)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the artist';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _lyricsController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the lyrics';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Lyrics',
                      labelStyle: TextStyle(color: Color(0xFF0b0302)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb2855d)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Color(0xFF0b0302)),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFb2855d),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text('Fetch Lyrics'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final song = Song(
                              title: _titleController.text,
                              artist: _artistController.text,
                              lyrics: _lyricsController.text,
                              imageName:
                                  _newImagePath != null ? _newImagePath : null,
                              favorited: false, // Default to false
                            );
                            print(_lyricsController.text);
                            songController.addSong(context, song,
                                _imagePath != null ? _imagePath : '');
                          }
                          //Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFb2855d),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text('Add Song'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
