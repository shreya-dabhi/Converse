import 'package:converse/components/my_button.dart';
import 'package:converse/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // login method
  void login(BuildContext context) async {
    // auth service instance
    final authService = AuthService();

    void showSnackBar(String errorMessage) {
      // show snack bar for field error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
      showSnackBar('Please enter value in field.');
      return;
    } else {
      // sign in method
      try {
        // show spinner while doing login user
        setState(() {
          _isLoading = true;
        });

        await authService.signInWithEmailAndPassword(
          _emailController.text,
          _pwController.text,
        );

        // hide spinner after successfully login process
        setState(() {
          _isLoading = false;
        });
      }
      // error
      catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Invalid Username or Password.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo / icon
            Icon(
              Icons.message_rounded,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 20,
            ),

            // message
            Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // email
            MyTextField(
              hintText: 'Enter Email',
              controller: _emailController,
              prefixIcon: const Icon(Icons.email_rounded),
            ),

            const SizedBox(
              height: 10,
            ),

            // password
            MyTextField(
              hintText: 'Enter Password',
              obscureText: !_isPasswordVisible,
              controller: _pwController,
              prefixIcon: const Icon(
                Icons.key_rounded,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // login
            MyButton(
              text: 'Login',
              onTap: () => login(context),
              showSpinner: _isLoading,
            ),

            const SizedBox(
              height: 25,
            ),

            // sign up now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Sign Up Now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
