import 'package:flutter/material.dart';
import 'package:song_lyrics_app/services/admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/views/test_auth.dart';

class AuthController {
  final AdminService _adminService = AdminService();

  Future<void> login(String username, String password) async {
    try {
      final response = await _adminService.verifyLogin(username, password);
      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('admin_id', response.id);
        prefs.setString('admin_username', response.username);
        // prefs.setString('admin', response);
        // String? username = prefs.getString('admin_username');
        // print(username);
        print('Login successful');
      } else {
        print('Invalid credentials');
      }
    } catch (e) {
      print('Login error : $e');
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return LoginTest();
      }),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout Success'),
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('admin_id');
    } catch (e) {
      print('isLogin Error : $e');
      return false;
    }
  }
}
