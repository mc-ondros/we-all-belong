//DART
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const LoginApp());
}

// Main App Widget
class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(title: 'Welcome back :)'),
    );
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

  // Function to handle login logic
  void handleLogin() {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      print(
          "Logging in with Email: ${emailController.text}, Password: ${passwordController.text}");
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

  const LoginPage({Key? key, required this.title}) : super(key: key);

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
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'email',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.emailController,
                onChanged: (value) => controller.email.value = value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Password Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'password',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.passwordController,
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
