import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:song_lyrics_app/controllers/song_controller.dart';
import 'package:song_lyrics_app/models/song.dart';

class EditSongScreen extends StatefulWidget {
  Song song;
  EditSongScreen({required this.song});
  @override
  _EditSongScreenState createState() => _EditSongScreenState();
}

class _EditSongScreenState extends State<EditSongScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SongController songController = SongController();
  late TextEditingController _titleController;
  late TextEditingController _artistController = TextEditingController();
  late TextEditingController _lyricsController = TextEditingController();
  String? _imageName;
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        //_newImagePath = newImagePath;
        _imagePath = image.path;
        _imageName = image.name;
      });
    }
  }

  Future<void> _fetchLyricsWithLoadingIndicator(BuildContext context) async {
    _showLoadingIndicator(context);

    String? lyrics = await songController.fetchLyrics(
      context,
      _artistController.text.trim(),
      _titleController.text.trim(),
    );

    _hideLoadingIndicator(context);

    if (lyrics != null) {
      setState(() {
        _lyricsController.text = lyrics;
      });
    }
  }

  void _showLoadingIndicator(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(hours: 1),
        content: Row(
          children: [
            CircularProgressIndicator(
              color: Color(0xFFb2855d),
            ),
            SizedBox(width: 16),
            Text('Fetching lyrics...'),
          ],
        ),
      ),
    );
  }

  void _hideLoadingIndicator(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.song.title);
    _artistController = TextEditingController(text: widget.song.artist);
    _lyricsController = TextEditingController(text: widget.song.lyrics);
    _imagePath = widget.song.imagePath ?? null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Song'),
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
                          _fetchLyricsWithLoadingIndicator(context);
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
                              id: widget.song.id,
                              title: _titleController.text,
                              artist: _artistController.text,
                              lyrics: _lyricsController.text,
                              imagePath: _imagePath ?? null,
                              favorited: widget.song.favorited,
                            );
                            print(_lyricsController.text);
                            songController.editSong(
                                context, song, _imageName ?? null);
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
                        child: Text('Edit Song'),
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
