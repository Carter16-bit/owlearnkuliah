import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owlearn/handlers/search/searchhandler.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';
import 'package:owlearn/handlers/posts/commentshandler.dart';
import 'package:owlearn/handlers/posts/likedislikehandler.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchHandler _searchHandler = SearchHandler();
  LikeDislikeHandler _likeDislikeHandler = LikeDislikeHandler();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari Posts!',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _query = _searchController.text;
                });
              },
            ),
          ),
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Carilah postingan yang anda inginkan!'))
          : StreamBuilder<QuerySnapshot>(
              stream: _searchHandler.searchPosts(_query),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var posts = snapshot.data!.docs;

                if (posts.isEmpty) {
                  return const Center(child: Text('Tidak ada postingan yang ditemukan.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(5.0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    var postId = post.id;

                    return Card(
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post['content']),
                            const SizedBox(height: 8),
                            Text('${post['username']}', style: const TextStyle(fontWeight: FontWeight.w300)),
                            Text('Likes: ${post['likes']}, Dislikes: ${post['dislikes']}', style: const TextStyle(fontWeight: FontWeight.w300)),
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
                    );
                  },
                );
              },
            ),
    );
  }
}
