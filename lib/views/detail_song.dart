import 'package:flutter/material.dart';
import 'package:song_lyrics_app/models/song.dart';

class DetailTestScreen extends StatefulWidget {
  final Song? song;
  const DetailTestScreen({super.key, this.song});

  @override
  State<DetailTestScreen> createState() => _DetailTestScreenState();
}

class _DetailTestScreenState extends State<DetailTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Center(child: Text('${widget.song?.id}')),
    );
  }
}
