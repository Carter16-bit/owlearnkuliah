import 'package:cloud_firestore/cloud_firestore.dart';

// Contoh: orang meninju basket sepak
class SearchHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sifat search ini baru teraplikasikan pada yaaa posts setelah tanggal 20?
  // Intinya yang terdapat di firestore kita dengan keywords lists didalamnya
  Stream<QuerySnapshot> searchPosts(String query) {
    return _firestore
      .collection('posts')
      .where('keywords', arrayContains: query.toLowerCase())
      .snapshots();
  }

  List<String> generateKeywords(String text) {
    final words = text.toLowerCase().split(' ');
    return words.toSet().toList();
  }

  Future<void> createPost({
    required String username,
    required String title,
    required String content,
  }) async {
    final keywords = generateKeywords('$title $content');

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
        'keywords': keywords, // Ini implementasi baruu
      });
    } catch (e) {
      print('Error mendapatkan post: $e');
    }
  }
}
