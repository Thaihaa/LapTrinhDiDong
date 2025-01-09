import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotify_clone_nhom8/auth/signin.dart';
import 'package:spotify_clone_nhom8/models/album.dart';
import 'package:spotify_clone_nhom8/models/song.dart';
import 'package:spotify_clone_nhom8/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Album>> _albumsFuture = _fetchAlbums();
  late Future<List<Song>> _songsFuture = _fetchSongs();

  Future<List<Album>> _fetchAlbums() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    return _apiService.fetchAlbums(token);
  }

  Future<List<Song>> _fetchSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    return _apiService.fetchSongs(token);
  }

  Future<void> _addAlbum(Album newAlbum) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    // In log JSON để kiểm tra dữ liệu
    print('Request JSON: ${jsonEncode(newAlbum.toJson())}');

    try {
      await _apiService.addAlbum(token, newAlbum);
      setState(() {
        _albumsFuture = _fetchAlbums();
      });
    } catch (e) {
      print('Error adding album: $e');
      rethrow;
    }
  }

  Future<void> _updateAlbum(int id, Album updatedAlbum) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    await _apiService.updateAlbum(token, id, updatedAlbum);
    setState(() {
      _albumsFuture = _fetchAlbums();
    });
  }

  Future<void> _deleteAlbum(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    await _apiService.deleteAlbum(token, id);
    setState(() {
      _albumsFuture = _fetchAlbums();
    });
  }

  Future<void> _addSong(Song newSong) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    await _apiService.addSong(token, newSong);
    setState(() {
      _songsFuture = _fetchSongs();
    });
  }

  Future<void> _updateSong(int id, Song updatedSong) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    await _apiService.updateSong(token, id, updatedSong);
    setState(() {
      _songsFuture = _fetchSongs();
    });
  }

  Future<void> _deleteSong(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    await _apiService.deleteSong(token, id);
    setState(() {
      _songsFuture = _fetchSongs();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Xóa token
    bool isRemoved = await prefs.remove('jwt_token');

    if (isRemoved) {
      print('Token removed successfully.');
    } else {
      print('Failed to remove token.');
    }

    // Kiểm tra lại xem token còn tồn tại không
    String? token = prefs.getString('jwt_token');
    if (token == null) {
      print('Token đã được xóa.');
    } else {
      print('Token vẫn còn: $token');
    }

    // Điều hướng về màn hình login và xóa toàn bộ stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SigninPage()),
      (Route<dynamic> route) => false,
    );

    // Hiển thị thông báo đăng xuất thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );
  }

  void _showAlbumDialog({Album? album}) async {
    final nameController = TextEditingController(text: album?.name ?? '');
    final artUrlController = TextEditingController(text: album?.artUrl ?? '');
    final selectedSongs = <int>{};
    final allSongs = await _fetchSongs();

    if (album != null) {
      selectedSongs.addAll(album.songs.map((song) => song.id!));
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(album == null ? 'Add Album' : 'Edit Album'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: artUrlController,
                  decoration: const InputDecoration(labelText: 'Art URL'),
                ),
                const SizedBox(height: 16),
                const Text('Select Songs:'),
                ...allSongs.map((song) {
                  return StatefulBuilder(
                    // Sử dụng StatefulBuilder để đảm bảo trạng thái được cập nhật trong dialog
                    builder: (context, setStateDialog) {
                      return CheckboxListTile(
                        title: Text(song.name ?? ''),
                        value: selectedSongs.contains(song.id),
                        onChanged: (bool? isSelected) {
                          setStateDialog(() {
                            // Cập nhật trạng thái trong dialog
                            if (isSelected == true) {
                              selectedSongs.add(song.id!);
                            } else {
                              selectedSongs.remove(song.id!);
                            }
                          });
                        },
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newAlbum = Album(
                  id: album?.id ?? 0,
                  name: nameController.text,
                  artUrl: artUrlController.text,
                  songs: allSongs
                      .where((song) => selectedSongs.contains(song.id))
                      .toList(),
                );
                if (album == null) {
                  await _addAlbum(newAlbum);
                } else {
                  await _updateAlbum(album.id, newAlbum);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSongDialog({Song? song}) {
    final nameController = TextEditingController(text: song?.name ?? '');
    final singerController = TextEditingController(text: song?.singer ?? '');
    final albumController = TextEditingController(text: song?.album ?? '');
    final audioUrlController =
        TextEditingController(text: song?.audioUrl ?? '');
    final albumArtUrlController =
        TextEditingController(text: song?.albumArtUrl ?? '');
    final durationController =
        TextEditingController(text: song?.duration?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(song == null ? 'Add Song' : 'Edit Song'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: singerController,
                  decoration: const InputDecoration(labelText: 'Singer'),
                ),
                TextField(
                  controller: albumController,
                  decoration: const InputDecoration(labelText: 'Album'),
                ),
                TextField(
                  controller: audioUrlController,
                  decoration: const InputDecoration(labelText: 'Audio URL'),
                ),
                TextField(
                  controller: albumArtUrlController,
                  decoration: const InputDecoration(labelText: 'Album Art URL'),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newSong = Song(
                  id: song?.id ?? 0,
                  name: nameController.text,
                  singer: singerController.text,
                  album: albumController.text,
                  duration: int.tryParse(durationController.text) ?? 0,
                  audioUrl: audioUrlController.text,
                  albumArtUrl: albumArtUrlController.text,
                );
                if (song == null) {
                  await _addSong(newSong);
                } else {
                  await _updateSong(song.id!, newSong);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 236, 195),
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _albumsFuture = _fetchAlbums();
                _songsFuture = _fetchSongs();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 211, 245, 221),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showAlbumDialog(),
                    icon: const Icon(Icons.library_music),
                    label: const Text("Thêm Album"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showSongDialog(),
                    icon: const Icon(Icons.music_note),
                    label: const Text("Thêm Bài Hát"),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Danh sách Album",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Album>>(
                future: _albumsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No albums found'));
                  } else {
                    final albums = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return ListTile(
                          title: Text(album.name),
                          subtitle: Text('ID: ${album.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showAlbumDialog(album: album),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteAlbum(album.id),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Danh sách Bài Hát",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Song>>(
                future: _songsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No songs found'));
                  } else {
                    final songs = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return ListTile(
                          title: Text(song.name ?? ''),
                          subtitle: Text('${song.singer} - ${song.album}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showSongDialog(song: song),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSong(song.id!),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
