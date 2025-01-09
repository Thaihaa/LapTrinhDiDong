import 'package:flutter/material.dart';
import '../models/song.dart';

class SongItem extends StatelessWidget {
  final Song song;

  SongItem({required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.name!),
      subtitle: Text('${song.singer} - ${song.album}'),
      trailing: Text('${song.duration}s'),
      onTap: () {
        // Điều hướng đến màn hình chi tiết bài hát
      },
    );
  }
}
