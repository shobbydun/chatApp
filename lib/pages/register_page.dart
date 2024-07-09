import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/components/my_button.dart';
import 'package:messaging_app/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmpwController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  void register(BuildContext context) async {
    final _auth = AuthService();

    if (_pwController.text == _confirmpwController.text) {
      try {
        // Call signUpWithEmailAndPassword instead of signInWithEmailAndPassword
        await _auth.signUpWithEmailAndPassword(
          _emailController.text, 
          _pwController.text,
        );

        // Registration successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Registration Success🎉"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Registration failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Registration Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Passwords don't match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords Don't Match"),
          content: Text("Please make sure your passwords match."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 50),

              Text(
                'Become one of us!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 25),

              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),

              SizedBox(height: 10),
              MyTextfield(
                hintText: "Password", 
                obscureText: true,
                controller: _pwController,
              ),

              SizedBox(height: 10),
              MyTextfield(
                hintText: "Confirm Password", 
                obscureText: true,
                controller: _confirmpwController,
              ),

              SizedBox(height: 25),

              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
