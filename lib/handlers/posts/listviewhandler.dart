import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owlearn/UIs/profilepage/profilorang.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';
import 'package:owlearn/handlers/posts/commentshandler.dart';
import 'likedislikehandler.dart';

class PostListView extends StatefulWidget {
  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final LikeDislikeHandler _likeDislikeHandler = LikeDislikeHandler();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //Comot data secara real-time
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var posts = snapshot.data!.docs;

        // Dibikin Listview dan card biar cakep
        return ListView.builder(
          padding: const EdgeInsets.all(5.0),
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            var postId = post.id;

            return Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        post['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0), // Padding bawah
                          child: Text(post['content']),
                        ),
                        // Ini fungsi biar kita bisa nammpilin data user yang menjadi author atau pembuat dari post yang telah dibuat
                        InkWell(
                          onTap: () async {
                            // Comot data user
                            var userSnapshot = await FirebaseFirestore.instance
                                .collection('users')
                                .where('username', isEqualTo: post['username'])
                                .get();

                            if (userSnapshot.docs.isNotEmpty) {
                              var userDoc = userSnapshot.docs.first;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilOrang(
                                    username: userDoc['username'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            post['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'Likes: ${post['likes']}, Dislikes: ${post['dislikes']}',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              iconSize: 20.0,
                              onPressed: () async {
                                String? uid = await FirebaseAuthHandler().getUid();
                                if (uid != null) {
                                  _likeDislikeHandler.toggleLike(postId, uid);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.thumb_down),
                              iconSize: 20.0,
                              onPressed: () async {
                                String? uid = await FirebaseAuthHandler().getUid();
                                if (uid != null) {
                                  _likeDislikeHandler.toggleDislike(postId, uid);
                                }
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              iconSize: 20.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsScreen(postId: postId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Intipan komentar di sini
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('createdAt', descending: true)
                          .limit(3)
                          .snapshots(),
                      builder: (context, commentSnapshot) {
                        if (!commentSnapshot.hasData || commentSnapshot.data!.docs.isEmpty) {
                          return const Text('Belum ada komentar...');
                        }

                        var comments = commentSnapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: comments.map((comment) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${comment['username']}: ${comment['comment']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
