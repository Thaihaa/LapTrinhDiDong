import 'dart:convert';

import 'package:spotify_clone_nhom8/services/api_client.dart';
import 'package:spotify_clone_nhom8/services/auth_service.dart';

class Auth {
  static final AuthService _authService = AuthService();
  static final ApiClient _apiClient = ApiClient();

  // Đăng nhập
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      // Gọi AuthService để xử lý đăng nhập
      var result = await _authService.login(username, password);

      if (result['success'] == true) {
        return result; // Trả về kết quả thành công từ AuthService
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Đăng nhập thất bại'
        };
      }
    } catch (e) {
      // Bắt lỗi và trả về thông báo lỗi
      return {
        'success': false,
        'message': 'Lỗi mạng hoặc hệ thống: ${e.toString()}'
      };
    }
  }

  // Đăng ký tài khoản mới
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String initials,
    required String role,
  }) async {
    // Tạo body để gửi lên API
    Map<String, dynamic> body = {
      "username": username,
      "email": email,
      "password": password,
      "initials": initials,
      "role": role,
    };

    // Gọi API đăng ký thông qua ApiClient
    try {
      var response = await _apiClient.post('Authenticate/register', body: body);

      // Xử lý kết quả từ API
      if (response.statusCode == 200) {
        // Chuyển đổi body JSON từ API thành Map
        var result = jsonDecode(response.body);
        return {'success': true, 'message': 'Đăng ký thành công', ...result};
      } else {
        return {
          'success': false,
          'message': 'Đăng ký thất bại, mã lỗi: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }
}
