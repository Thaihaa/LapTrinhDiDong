import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Screen"),
      ),
      body: const Center(
        child: Text(
          "This is the Settings Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
