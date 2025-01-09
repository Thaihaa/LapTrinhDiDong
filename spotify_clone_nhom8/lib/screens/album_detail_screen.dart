import 'package:flutter/material.dart';
import 'package:spotify_clone_nhom8/models/album.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: album.songs.length,
        itemBuilder: (context, index) {
          final song = album.songs[index];
          return ListTile(
            leading: song.albumArtUrl != null
                ? Image.network(
                    song.albumArtUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.music_note, size: 40),
            title: Text(
              song.name ?? 'Unknown Song',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              song.singer ?? 'Unknown Artist',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // Chức năng phát nhạc
                print('Play song: ${song.name}');
              },
            ),
          );
        },
      ),
    );
  }
}
