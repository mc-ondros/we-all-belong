//DART
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_all_belong/features/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:we_all_belong/features/homepage/homepage_screen.dart';

// Main App Widget
class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage(title: 'Welcome back :)');
  }
}

// Controller for Login Page
class LoginController extends GetxController {
  // Text editing controllers to retrieve input from TextFields
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Observables to track if fields are empty
  var email = ''.obs;
  var password = ''.obs;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle login logic
  void handleLogin() async {
    String emailInput = emailController.text.trim();
    String passwordInput = passwordController.text;

    if (emailInput.isEmpty || passwordInput.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Show a loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Attempt to sign in with Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: emailInput,
        password: passwordInput,
      );

      // Dismiss the loading indicator
      Get.back();

      // Navigate to HomePage upon successful login
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      Get.back(); // Dismiss the loading indicator
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      Get.snackbar(
        "Login Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Dismiss the loading indicator
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// Login Page Widget
class LoginPage extends StatelessWidget {
  final String title;

  const LoginPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    print("Building LoginPage");
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title Text
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Email Input Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'email',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.emailController,
                onChanged: (value) => controller.email.value = value,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'email',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Password Input Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'password',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.passwordController,
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'password',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: controller.handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'JUMP IN',
                  style: TextStyle(color: Colors.black, letterSpacing: 1.5),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(BottomNavigationBarCustom());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'JUMP IN',
                  style: TextStyle(color: Colors.black, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 40),

              // Placeholder for Logo
              Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text(
                  'LOGO',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
