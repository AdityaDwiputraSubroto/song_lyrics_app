class Song {
  final int? id;
  final String title;
  final String artist;
  final String lyrics;
  final bool favorited;

  Song({
    this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.favorited,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'favorited': favorited ? 1 : 0,
    };
  }
}
