import 'package:flutter/material.dart';
import 'package:song_lyrics_app/controllers/auth_controller.dart';

class EditUsernameScreen extends StatefulWidget {
  final String username;

  EditUsernameScreen({required this.username});

  @override
  _EditUsernameScreenState createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  Future<void> _saveUsername() async {
    if (_formKey.currentState!.validate()) {
      await AuthController().changeUsername(context, _usernameController.text);
    }
  }

  @override
  void initState() {
    _usernameController.text = widget.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe7c197),
      appBar: AppBar(
        title: Text('Edit Username'),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Edit Username',
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
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFb2855d),
                    foregroundColor: Colors.white, // Warna teks tombol
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
