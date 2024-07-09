import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/components/my_button.dart';
import 'package:messaging_app/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final void Function()? onTap;

  LoginPage({
    Key? key, // Corrected the super.key
    required this.onTap,
  }) : super(key: key);

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      // Perform input validation if needed
      if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Please fill in all fields."),
          ),
        );
        return;
      }

      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login failed. ${e.toString()}"), // Provide a meaningful error message
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView to handle keyboard overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),

              // Welcome message
              Text(
                'Welcome Back!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),

              // Email Textfield
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),

              // Password Textfield
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),

              const SizedBox(height: 25),

              // Login button
              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),

              const SizedBox(height: 25),

              // Register if not a member
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a Member?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Register now",
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
