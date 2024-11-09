import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();
  
  final Rx<File?> profileImage = Rx<File?>(null);
  final _picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  Future<void> loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          final data = userData.data()!;
          nameController.text = data['name'] ?? '';
          bioController.text = data['bio'] ?? '';
          genderController.text = data['gender'] ?? '';
          nationalityController.text = data['nationality'] ?? '';
          ageController.text = data['age']?.toString() ?? '';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'bio': bioController.text,
          'gender': genderController.text,
          'nationality': nationalityController.text,
          'age': int.tryParse(ageController.text),
        });

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    genderController.dispose();
    nationalityController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
