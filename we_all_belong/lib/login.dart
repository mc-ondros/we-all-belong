import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_all_belong/features/homepage/homepage_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/kyc/screens/kyc_screen.dart';

// Main App Widget
class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage(title: 'Welcome back :)');
  }
}

// Controller for Login Page with Firebase Integration
class LoginController extends GetxController {
  // Text editing controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Observables
  var email = ''.obs;
  var password = ''.obs;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Login Logic
  void handleLogin() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Get.back(); // Dismiss loading indicator

      // Check if email is verified
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        Get.dialog(
          AlertDialog(
            title: Text(
              'Email Not Verified',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please verify your email before logging in.',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Didn\'t receive the email?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await userCredential.user?.sendEmailVerification();
                  Get.back();
                  Get.snackbar(
                    "Email Sent",
                    "A new verification email has been sent.",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: Text(
                  'Resend Email',
                  style: GoogleFonts.poppins(),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
        // Sign out the user since they're not verified
        await _auth.signOut();
        return;
      }

      // Check if user has completed KYC
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists || !(userDoc.data() as Map<String, dynamic>)['isOnboarded']) {
        Get.offAll(() => KYCScreen());
        return;
      }

      // If user is verified and has completed KYC, proceed to homepage
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      Get.back(); // Dismiss loading indicator
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      Get.snackbar(
        "Login Failed",
        errorMessage,
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

// Login Page UI
class LoginPage extends StatelessWidget {
  final String title;

  const LoginPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Modern Split Style Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We all',
                      style: GoogleFonts.abrilFatface(
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: Colors.deepPurpleAccent[700],
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'belong.',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent[400],
                        letterSpacing: -2,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Email Field with Firebase Controller
                TextField(
                  controller: controller.emailController,
                  onChanged: (value) => controller.email.value = value,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 16),

                // Password Field with Firebase Controller
                TextField(
                  controller: controller.passwordController,
                  onChanged: (value) => controller.password.value = value,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 12),
                
                // Register Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add registration navigation here
                    },
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Button with Firebase Authentication
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Register Link
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const RegisterPage()),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: GoogleFonts.poppins(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}