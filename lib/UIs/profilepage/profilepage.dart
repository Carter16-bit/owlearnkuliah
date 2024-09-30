import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _email;
  String? _bio;

  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    FirebaseAuthHandler authHandler = FirebaseAuthHandler();
    String? uid = await authHandler.getUid();

    if (uid != null) {
      // Comot data
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'];
          _email = userDoc['email'];
          _bio = userDoc['bio'] ?? 'Hantu.';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    FirebaseAuthHandler authHandler = FirebaseAuthHandler();
    String? uid = await authHandler.getUid();

    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bio': _bioController.text.isNotEmpty ? _bioController.text : _bio,
      });

      setState(() {
        _bio = _bioController.text;
      });

      // Profil udah okeh anjay
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil Terbarui!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_username != null ? 'Profil $_username' : 'Loading...', style: const TextStyle(fontWeight: FontWeight.bold))
      ),
      body: _username == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _username ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _email ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bioController..text = _bio ?? '',
                    maxLines: 2,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan Tentangmu!',
                      hintMaxLines: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveProfile();
                    },
                    child: const Text('Simpan Profil'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }
}
