import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/features/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:we_all_belong/login.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      try {
        // Attempt to sign in with stored credentials
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.offAll(() => const BottomNavigationBarCustom());
      } catch (e) {
        // If login fails, clear stored credentials
        await prefs.clear();
        Get.offAll(() => const LoginApp());
      }
    } else {}
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
    await prefs.clear();
    Get.offAll(() => const LoginApp());
  }
}
