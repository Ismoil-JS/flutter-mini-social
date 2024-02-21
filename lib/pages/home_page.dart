import 'package:flutter/material.dart';
import 'package:socials/components/my_drawer.dart';
import 'package:socials/components/my_list_tile.dart';
import 'package:socials/components/my_post_button.dart';
import 'package:socials/components/my_textfield.dart';
import 'package:socials/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    // post message if controller is not empty
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('S O C I A L S'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield for post
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    hintText: "Post something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                PostButton(onTap: postMessage)
              ],
            ),
          ),

          // list of posts
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                // show loading if snapshot is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // if snapshot has data, get all posts
                final posts = snapshot.data!.docs;

                // if snapshot has no data, show error message
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text('No posts yet... 😢'),
                    ),
                  );
                }

                // return a list of posts
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // get individual post
                      final post = posts[index];

                      // get info from post
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];
                      // Timestamp timestamp = post['Timestamp'];

                      // return a post
                      return MyListTile(title: message, subtitle: userEmail);
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
