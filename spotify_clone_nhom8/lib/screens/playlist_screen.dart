import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone_nhom8/models/album.dart';
import 'package:spotify_clone_nhom8/screens/album_detail_screen.dart';
import 'package:spotify_clone_nhom8/services/api_service.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  late Future<List<Album>> _albumsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _albumsFuture = _fetchAlbums();
  }

  Future<String?> _getJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<List<Album>> _fetchAlbums() async {
    try {
      final String? token = await _getJwtToken();
      if (token == null || token.isEmpty) {
        throw Exception('No token found or token is empty');
      }

      final albums = await _apiService.fetchAlbums(token);
      return albums;
    } catch (e) {
      print('Error fetching albums: $e'); // In lỗi chi tiết
      rethrow; // Ném lỗi ra ngoài để hiển thị trong UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Playlist',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load albums',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No favorite albums yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final albums = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return ListTile(
                leading: album.artUrl != null
                    ? Image.network(
                        album.artUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.album, size: 50),
                title: Text(
                  album.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${album.songs.length} songs',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  // Điều hướng đến AlbumDetailScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumDetailScreen(album: album),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
