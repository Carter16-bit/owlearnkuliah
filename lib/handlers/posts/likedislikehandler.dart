import 'package:cloud_firestore/cloud_firestore.dart';
/*
Bagan sini dapet copy dari StackOverflow sebab logikanya agak ribet wkwkwkwk
Sistemnya disini yaitu:
- Pengguna liked sebuah post maka like akan dihapus juga jika dipencet lagi
- Pengguna liked sebuah post tetapi memencet dislike maka pilihannya berpindah ke dislike
- Dan sebaliknya
*/
class LikeDislikeHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleLike(String postId, String uid) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    //Disini fungsinya kita ganti jadi List, agar userID yang melakukan like atau dislike dapat disimpan ke sistem firestore
    //Sistemnya juga bersifat server side, jadi gak bisa dispam maupun diexploitasi kecuali dengan reverse engineer
    List<dynamic> userLiked = postSnapshot['userLiked'] != null
        ? List.from(postSnapshot['userLiked'])
        : [];
    List<dynamic> userDisliked = postSnapshot['userDisliked'] != null
        ? List.from(postSnapshot['userDisliked'])
        : [];

    bool hasLiked = userLiked.contains(uid);
    bool hasDisliked = userDisliked.contains(uid);
    if (hasLiked) {
      await postRef.update({
        'likes': FieldValue.increment(-1),
        'userLiked': FieldValue.arrayRemove([uid]),
      });
    } else {
      if (hasDisliked) {
        await postRef.update({
          'dislikes': FieldValue.increment(-1),
          'userDisliked': FieldValue.arrayRemove([uid]),
        });
      }
      await postRef.update({
        'likes': FieldValue.increment(1),
        'userLiked': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> toggleDislike(String postId, String uid) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    List<dynamic> userLiked = postSnapshot['userLiked'] != null
        ? List.from(postSnapshot['userLiked'])
        : [];
    List<dynamic> userDisliked = postSnapshot['userDisliked'] != null
        ? List.from(postSnapshot['userDisliked'])
        : [];

    bool hasLiked = userLiked.contains(uid);
    bool hasDisliked = userDisliked.contains(uid);
    if (hasDisliked) {
      await postRef.update({
        'dislikes': FieldValue.increment(-1),
        'userDisliked': FieldValue.arrayRemove([uid]),
      });
    } else {
      if (hasLiked) {
        await postRef.update({
          'likes': FieldValue.increment(-1),
          'userLiked': FieldValue.arrayRemove([uid]),
        });
      }
      await postRef.update({
        'dislikes': FieldValue.increment(1),
        'userDisliked': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
