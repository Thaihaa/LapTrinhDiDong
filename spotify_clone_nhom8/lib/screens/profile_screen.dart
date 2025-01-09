import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone_nhom8/auth/signin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://cdn2.fptshop.com.vn/unsafe/Meme_meo_tang_hoa_4_33eea46670.jpg',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'hathai2972003@gmail.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Thái Hà',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PUBLIC PLAYLISTS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
