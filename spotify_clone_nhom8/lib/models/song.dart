class Song {
  Song({
    required this.id,
    required this.name,
    required this.singer,
    required this.album,
    required this.duration,
    required this.audioUrl,
    required this.albumArtUrl,
  });

  final int? id;
  final String? name;
  final String? singer;
  final String? album;
  final int? duration;
  final String? audioUrl;
  final String? albumArtUrl;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json["id"],
      name: json["name"],
      singer: json["singer"],
      album: json["album"],
      duration: json["duration"],
      audioUrl: json["audioUrl"],
      albumArtUrl: json["albumArtUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "singer": singer,
        "album": album,
        "duration": duration,
        "audioUrl": audioUrl,
        "albumArtUrl": albumArtUrl,
      };
}
