import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // register method
  void register(BuildContext context) async {
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

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _pwController.text.isEmpty ||
        _confirmPwController.text.isEmpty) {
      showSnackBar('Please enter value in field.');
      return;
    } else if (_pwController.text != _confirmPwController.text) {
      showSnackBar('Password didn\'t match.');
      return;
    } else if (_pwController.text.length < 6) {
      showSnackBar('Please provide password with minimum 6 characters.');
      return;
    } else {
      // sign up a new user
      try {
        // show spinner while registering new user
        setState(() {
          _isLoading = true;
        });

        await authService.signUpUser(
            _nameController.text, _emailController.text, _pwController.text);

        // hide spinner after successfully register process
        setState(() {
          _isLoading = false;
        });
      }
      // handle error
      catch (e) {
        // hide spinner after error happens while register process
        setState(() {
          _isLoading = false;
        });
        showSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
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
                'Let\'s create an account for you',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // name
              MyTextField(
                hintText: 'Enter Name',
                controller: _nameController,
                prefixIcon: const Icon(
                  Icons.person,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // email
              MyTextField(
                hintText: 'Enter Email',
                controller: _emailController,
                prefixIcon: const Icon(
                  Icons.email_rounded,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // password
              MyTextField(
                hintText: 'Enter Password',
                controller: _pwController,
                obscureText: !_isPasswordVisible,
                prefixIcon: const Icon(
                  Icons.key_rounded,
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // confirm password
              MyTextField(
                hintText: 'Enter Confirm Password',
                controller: _confirmPwController,
                obscureText: !_isConfirmPasswordVisible,
                prefixIcon: const Icon(
                  Icons.key_rounded,
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // login
              MyButton(
                text: 'Register',
                onTap: () => register(context),
                showSpinner: _isLoading,
              ),

              const SizedBox(
                height: 25,
              ),

              // sign in now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login Now',
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
      ),
    );
  }
}
