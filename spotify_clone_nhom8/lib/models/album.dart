import 'package:spotify_clone_nhom8/models/song.dart';

class Album {
  final int id;
  final String name;
  final String? artUrl;
  final List<Song> songs;

  Album({
    required this.id,
    required this.name,
    this.artUrl,
    required this.songs,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? 0, // Đảm bảo id không null
      name: json['name'] ?? 'Unknown Album', // Tên mặc định nếu không có
      artUrl: json['artUrl'], // Có thể null
      songs: (json['songs'] as List<dynamic>? ??
              []) // Xử lý null cho danh sách songs
          .map((e) => Song.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artUrl': artUrl,
      'songs': songs.map((song) => song.toJson()).toList(),
    };
  }
}
