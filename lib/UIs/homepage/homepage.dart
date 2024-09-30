import 'package:flutter/material.dart';
import 'package:owlearn/handlers/posts/listviewhandler.dart';
import 'package:owlearn/handlers/posts/postsbutton.dart';
// Simplistik bangets
class MenuRumah extends StatefulWidget {
  @override
  _MenuRumahState createState() => _MenuRumahState();
}

class _MenuRumahState extends State<MenuRumah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: PostListView(), // Ini bagus 👌
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostForm(), // Bikin postingan layaknya di efbi🤓 #belum support gambar btw
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
