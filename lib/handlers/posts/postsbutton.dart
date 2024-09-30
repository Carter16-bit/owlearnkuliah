import 'package:flutter/material.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';
import 'postshandler.dart';

class CreatePostForm extends StatefulWidget {
  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseAuthHandler _authHandler = FirebaseAuthHandler();
  final PostsHandler _postsHandler = PostsHandler();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  //Tombol untuk memulai argumen berfaidah :D
  //overall pasti keliatan sendiri deh konsepnya seperti apa

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      String? uid = await _authHandler.getUid();
      String? username = await _postsHandler.getUsername(uid!); // Ambil username

      if (username != null) {
        await _postsHandler.createPost(
          username: username,
          title: _titleController.text,
          content: _contentController.text,
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saat mengambil username!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Sebuah Post!', style: const TextStyle(fontWeight: FontWeight.bold)), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 20,
                decoration: const InputDecoration(labelText: 'Title', hintMaxLines: 20),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Konten', hintMaxLines: 200),
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _createPost,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
