class Song {
  final int? id;
  final String title;
  final String artist;
  final String lyrics;
  String? imageName;
  bool favorited;

  Song({
    this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    this.imageName,
    required this.favorited,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'imageName': imageName,
      'favorited': favorited ? 1 : 0,
    };
  }
}
