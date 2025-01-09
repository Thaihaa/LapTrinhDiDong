import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/singer.dart';
import '../models/song.dart';
import '../models/album.dart'; // Thêm import cho model Album

class ApiService {
  static const String baseUrl = "https://goodblueshop6.conveyor.cloud/api";

  // Fetch tất cả singers
  Future<List<Singer>> fetchSingers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Singers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Singer.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load singers: ${response.statusCode}');
    }
  }

  // Fetch tất cả songs
  Future<List<Song>> fetchSongs(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Songs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load songs: ${response.statusCode}');
    }
  }

  Future<void> addSong(String token, Song song) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Songs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(song.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Song added successfully');
    } else {
      throw Exception('Failed to add song: ${response.statusCode}');
    }
  }

  // Update an existing song
  Future<void> updateSong(String token, int id, Song song) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Songs/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(song.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update song: ${response.statusCode}');
    }
  }

  Future<void> deleteSong(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Songs/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // Xử lý mã phản hồi
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Song deleted successfully');
    } else {
      throw Exception('Failed to delete song: ${response.statusCode}');
    }
  }

  Future<List<Album>> fetchAlbums(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Albums'),
      headers: {
        'Authorization': 'Bearer $token', // Gửi token dưới dạng Bearer
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Album.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load albums: ${response.statusCode}');
    }
  }

  // Add a new album
  Future<http.Response> addAlbum(String token, Album album) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Albums'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(album.toJson()),
    );
    return response; // Đảm bảo trả về response
  }

  // Update an existing album
  Future<void> updateAlbum(String token, int id, Album album) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Albums/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(album.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update album: ${response.statusCode}');
    }
  }

  // Delete an album
  Future<void> deleteAlbum(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Albums/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete album: ${response.statusCode}');
    }
  }
}
