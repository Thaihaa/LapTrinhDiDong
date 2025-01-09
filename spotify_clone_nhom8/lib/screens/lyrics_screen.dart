import 'package:flutter/material.dart';

class LyricsScreen extends StatelessWidget {
  final String songName;
  final String singerName;
  final String lyrics;

  const LyricsScreen({
    Key? key,
    required this.songName,
    required this.singerName,
    required this.lyrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(songName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(singerName),
            Expanded(
              child: SingleChildScrollView(
                child: Text(lyrics),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
