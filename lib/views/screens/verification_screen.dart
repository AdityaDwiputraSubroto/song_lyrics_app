import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/controllers/auth_controller.dart';

class VerifyScreen extends StatefulWidget {
  final VoidCallback onVerified;

  VerifyScreen({required this.onVerified});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _verify() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      bool verified =
          await AuthController().verifyAdmin(context, username, password);

      if (verified) {
        Navigator.pop(context);
        widget.onVerified();
      } else {
        print('Not verified');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe7c197),
      appBar: AppBar(
        title: Text('Verify'),
        backgroundColor: Color(0xFFb2855d),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/logo.png',
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Overflow handling
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0b0302),
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/login-illustration.png',
                  height: 180,
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Color(0xFF0b0302)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb2855d)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb2855d)),
                    ),
                  ),
                  style: TextStyle(color: Color(0xFF0b0302)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFF0b0302)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb2855d)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb2855d)),
                    ),
                  ),
                  style: TextStyle(color: Color(0xFF0b0302)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFb2855d),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
