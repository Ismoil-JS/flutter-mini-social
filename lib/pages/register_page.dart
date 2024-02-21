import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socials/components/my_button.dart';
import 'package:socials/components/my_textfield.dart';
import 'package:socials/helpers/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controller
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register function
  void registerUser() async {
    // show loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // password match check
    if (passwordController.text != confirmPwController.text) {
      // pop loading dialog
      Navigator.pop(context);

      // show error dialog
      displayMessageToUser("Passwords do not match!", context);
    }
    // if password match
    else {
      // try to register user
      try {
        // create user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // create user document in firestore
        createUserDocument(userCredential);

        // pop loading dialog
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading dialog
        if (mounted) Navigator.pop(context);

        // show error dialog
        if (mounted) displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    // Check if the userCredential and user are not null
    if (userCredential != null && userCredential.user != null) {
      // Access the Firestore instance and add a document to the "Users" collection
      await FirebaseFirestore.instance
          .collection("Users") // Access the "Users" collection
          .doc(userCredential
              .user!.email) // Use the user's email as the document ID
          .set(
        // Set the data for the document
        {
          'email': userCredential.user!.email, // Set the email field
          'username': usernameController.text, // Set the username field
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 20),

              // name field
              const Text(
                'S O C I A L S',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              // username textfield
              MyTextfield(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController),

              const SizedBox(height: 10),

              // email textfield
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),

              const SizedBox(height: 10),

              // password textfield
              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextfield(
                  hintText: "Confirm password",
                  obscureText: true,
                  controller: confirmPwController),

              const SizedBox(height: 10),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // register button
              MyButton(text: "Register", onTap: registerUser),

              const SizedBox(height: 10),

              // don't have an account, sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Sign in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
