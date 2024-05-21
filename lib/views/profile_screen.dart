import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/controllers/auth_controller.dart';
import 'package:song_lyrics_app/views/edit_password_screen.dart';
import 'package:song_lyrics_app/views/edit_username_screen.dart';
import 'package:song_lyrics_app/views/verification_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  AuthController authController = AuthController();
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('admin_username') ?? 'Error get username';
    });
  }

  void _verifyAndNavigate(VoidCallback onVerified) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyScreen(onVerified: onVerified)),
    );
  }

  void _editPassword() {
    _verifyAndNavigate(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPasswordScreen()),
      );
    });
  }

  void _editUsername() {
    print('edit username');
    _verifyAndNavigate(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditUsernameScreen(
                  username: _username!,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            Text(
              _username ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editUsername,
              child: Text('Edit Username'),
            ),
            ElevatedButton(
              onPressed: _editPassword,
              child: Text('Edit Password'),
            ),
            ElevatedButton(
              onPressed: () => authController.logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
