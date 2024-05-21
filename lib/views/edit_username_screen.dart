import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_lyrics_app/controllers/auth_controller.dart';

class EditUsernameScreen extends StatefulWidget {
  String username;
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
      appBar: AppBar(
        title: Text('Edit Username'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUsername,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
