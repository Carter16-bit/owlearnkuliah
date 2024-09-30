import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owlearn/handlers/search/searchhandler.dart';

class PostsHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SearchHandler _searchHandler = SearchHandler(); 

  // Yay firestornya bisaaaa
  Future<String?> getUsername(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['username'];
      }
    } catch (e) {
      print('Error mengambil username: $e');
    }
    return null;
  }

  // ngeposting
  Future<void> createPost({
    required String username,
    required String title,
    required String content,
  }) async {
    final keywords = _searchHandler.generateKeywords('$title $content');
    try {
      await _firestore.collection('posts').add({
        'title': title,
        'content': content,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'dislikes': 0,
        'userLiked': [],
        'userDisliked': [],
        'keywords': keywords,
      });
    } catch (e) {
      print('Error membuat post: $e');
    }
  }

  Stream<QuerySnapshot> getPostsStream() {
    return _firestore.collection('posts').limit(10).orderBy('createdAt', descending: true).snapshots();
  }
}
