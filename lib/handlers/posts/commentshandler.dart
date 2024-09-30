import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';

class CommentsHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Comot data dari firestore
  Future<void> addComment(String postId, String username, String comment) async {
    try {
      await _firestore.collection('posts').doc(postId).collection('comments').add({
        'username': username,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      SnackBar(content: Text('Error menambahkan komentar: $e'));
    }
  }

  // Kita kumpulin dulu argumen masyarakat :D
  Stream<QuerySnapshot> getCommentsStream(String postId) {
    return _firestore.collection('posts').doc(postId).collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}

class CommentsScreen extends StatefulWidget {
  final String postId;
  //Kalau mau liat isi atau buat komentar jelas-jelas butuh postID dongg
  CommentsScreen({required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final CommentsHandler _commentsHandler = CommentsHandler();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  //Buat memulai bacotan
  Future<void> _addComment() async {
    String comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      String? username = await FirebaseAuthHandler().getUsername();

      if (username != null) {
        await _commentsHandler.addComment(widget.postId, username, comment);
        _commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Username tidak ditemukan.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Komentar', style: const TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentsHandler.getCommentsStream(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(5.0),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment = comments[index];
                    return Card(
                      child: ListTile(
                        title: Text(comment['username']),
                        subtitle: Text(comment['comment'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      )
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan komentar...',
                      hintMaxLines: 100,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
