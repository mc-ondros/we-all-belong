import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/profile_image_service.dart';
import '../../../core/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final genderController = TextEditingController();
  final pronounsController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();

  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = RxString('');
  final RxBool isLoading = false.obs;

  // Dietary preferences
  final RxBool isVegan = false.obs;
  final RxBool isHalal = false.obs;
  final RxBool isKosher = false.obs;

  // Disabilities
  final RxList<String> disabilities = <String>[].obs;
  final List<String> availableDisabilities = ['Physical', 'Sensorial', 'Intellectual', 'Learning', 'Emotional'];

  // Add userProfile to store all user data
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  final _picker = ImagePicker();
  final _profileImageService = Get.find<ProfileImageService>();

  // Check if controller is initialized
  @override
  bool get initialized => Get.isRegistered<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _loadCachedProfileImage();
  }

  Future<void> _loadCachedProfileImage() async {
    final cachedPath = await _profileImageService.getCachedImagePath();
    if (cachedPath != null) {
      profileImage.value = File(cachedPath);
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        isLoading.value = true;
        profileImage.value = File(image.path);

        // Upload and cache the image
        final url =
            await _profileImageService.uploadProfileImage(profileImage.value!);
        if (url != null) {
          profileImageUrl.value = url;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('Loading user data for: ${user.uid}');
        final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          debugPrint('User data exists in Firestore');
          // Store the complete user profile
          userProfile.value = UserProfileModel.fromFirebase(userData);

          // Update the text controllers
          final data = userData.data()!;
          debugPrint('Raw data from Firestore: $data');
          
          nameController.text = data['name'] ?? '';
          bioController.text = data['bio'] ?? '';
          genderController.text = data['gender'] ?? '';
          pronounsController.text = data['pronouns'] ?? '';
          nationalityController.text = data['nationality'] ?? '';
          ageController.text = data['age']?.toString() ?? '';
          
          // Update dietary preferences
          isVegan.value = data['isVegan'] ?? false;
          isHalal.value = data['isHalal'] ?? false;
          isKosher.value = data['isKosher'] ?? false;
          
          // Update disabilities
          disabilities.clear();
          if (data['disabilities'] != null) {
            disabilities.addAll(List<String>.from(data['disabilities']));
          }
          
          debugPrint('Controllers updated: Name=${nameController.text}, Gender=${genderController.text}');
          debugPrint('Disabilities: $disabilities');
        } else {
          debugPrint('No user data found in Firestore');
        }
      } else {
        debugPrint('No current user found');
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
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
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Create an updated profile with the new values
        final updatedProfile = UserProfileModel(
          uuid: user.uid,
          email: user.email ?? '',
          name: nameController.text,
          bio: bioController.text,
          gender: genderController.text,
          pronouns: pronounsController.text,
          nationality: nationalityController.text,
          age: int.tryParse(ageController.text),
          // Dietary preferences
          isVegan: isVegan.value,
          isHalal: isHalal.value,
          isKosher: isKosher.value,
          // Updated disabilities
          disabilities: disabilities,
          // Preserve existing values for other fields
          religiousOrientation: userProfile.value?.religiousOrientation,
          sexualPreference: userProfile.value?.sexualPreference,
          isOnboarded: userProfile.value?.isOnboarded ?? true,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updatedProfile.toJson());

        // Update the stored profile
        userProfile.value = updatedProfile;

        await Future.delayed(
            const Duration(seconds: 1)); // Simulate network delay

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null || age < 13 || age > 120) {
      return 'Please enter a valid age between 13 and 120';
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    genderController.dispose();
    pronounsController.dispose();
    nationalityController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
