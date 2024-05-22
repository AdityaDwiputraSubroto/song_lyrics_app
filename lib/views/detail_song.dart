import 'dart:io';
import 'package:flutter/material.dart';
import 'package:song_lyrics_app/models/song.dart';

class DetailTestScreen extends StatefulWidget {
  final Song? song;
  const DetailTestScreen({Key? key, this.song}) : super(key: key);

  @override
  State<DetailTestScreen> createState() => _DetailTestScreenState();
}

class _DetailTestScreenState extends State<DetailTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFb2855d),
        title: Text(
          'Detail Lyrics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Color(0xFFb2855d)),
                      borderRadius: BorderRadius.circular(
                          6.0), // Menambahkan border radius
                    ),
                    child: Image.file(
                      File(widget.song?.imageName ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.song?.title}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${widget.song?.artist}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity, // Mengatur lebar menjadi penuh
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFe7c197),
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Color(0xFFb2855d),
                  ),
                ),
                child: Text(
                  widget.song?.lyrics ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 134, 82, 36),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
