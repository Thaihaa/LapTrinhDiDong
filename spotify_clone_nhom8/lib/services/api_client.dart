import 'dart:convert';

import 'package:spotify_clone_nhom8/core/configs/config_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? Config_URL.baseUrl;

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    final token = await _getToken();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers, token),
    );
  }

  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final token = await _getToken();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers, token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final token = await _getToken();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers, token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final token = await _getToken();
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers, token),
    );
  }

  Map<String, String> _buildHeaders(
      Map<String, String>? headers, String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };
  }
}
