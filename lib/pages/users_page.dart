import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socials/components/my_back_button.dart';
import 'package:socials/components/my_list_tile.dart';
import 'package:socials/helpers/helper_functions.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // any error
          if (snapshot.hasError) {
            displayMessageToUser('Something went wrong!', context);
          }

          // show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text('No data');
          }

          // get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 25,
                ),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // list of users
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: ((context, index) {
                    final user = users[index];

                    final String userEmail = user['email'];
                    final String username = user['username'];

                    return MyListTile(title: username, subtitle: userEmail);
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
