import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable user model
  Rx<UserProfileModel> userModel = UserProfileModel(email: '', uuid: '').obs;

  // Observable Firebase user
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();

    // Listen to auth state changes
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
      if (firebaseUser != null) {
        // Load user profile when auth state changes
        loadUserProfile(firebaseUser.uid);
      } else {
        // Reset user model when logged out
        userModel.value = UserProfileModel(email: '', uuid: '');
      }
    });

    // Load initial user profile if user is already logged in
    if (_auth.currentUser != null) {
      loadUserProfile(_auth.currentUser!.uid);
    }
  }

  // Load user profile from Firestore
  Future<void> loadUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        userModel.value = UserProfileModel.fromFirebase(docSnapshot);
      } else {
        // Create a basic profile if it doesn't exist
        final newUser = UserProfileModel(
          uuid: uid,
          email: _auth.currentUser?.email ?? '',
          isOnboarded: false,
        );

        // Save the basic profile to Firestore
        await _firestore.collection('users').doc(uid).set(newUser.toJson());
        userModel.value = newUser;
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfileModel updatedProfile) async {
    try {
      if (user.value != null) {
        await _firestore.collection('users').doc(user.value!.uid).update(updatedProfile.toJson());

        userModel.value = updatedProfile;
      }
    } catch (e) {
      debugPrint('Error updating user profile: $e');
    }
  }
}
