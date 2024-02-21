import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // Logout
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              DrawerHeader(
                child: Icon(
                  Icons.account_circle,
                  size: 45.0,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 25.0),

              // home drawer items
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                // List of drawer items
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('H O M E '),
                  onTap: () {
                    Navigator.pop(context);

                    // Navigate to home page
                    Navigator.pushNamed(context, '/home_page');
                  },
                ),
              ),

              // profile drawer items
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                // List of drawer items
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('P R O F I L E'),
                  onTap: () {
                    Navigator.pop(context);

                    // Navigate to profile page
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              // users drawer items
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                // List of drawer items
                child: ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('U S E R S'),
                  onTap: () {
                    Navigator.pop(context);

                    // Navigate to users page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),
            ],
          ),

          // logout drawer items
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            // List of drawer items
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text('L O G O U T'),
              onTap: () {
                Navigator.pop(context);

                // Logout
                logout();
              },
            ),
          )
        ],
      ),
    );
  }
}
