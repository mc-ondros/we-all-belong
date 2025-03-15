import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_text/safe_text.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';
import 'package:we_all_belong/features/profile/controller/profile_controller.dart';
import 'package:we_all_belong/features/profile/widgets/user_labels_widget.dart';

import '../../../core/user_controller/user_controller.dart';

class WallController extends GetxController {
  ProfileController profileController = ProfileController().initialized
      ? Get.find()
      : Get.put(ProfileController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();
  var posts = <Map<String, dynamic>>[].obs;
  TextEditingController postController = TextEditingController();

  // Cache of user profiles to avoid repeated fetches
  final Map<String, UserProfileModel> _userProfileCache = {};

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() {
    _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final fetchedPosts = snapshot.docs.map((doc) => doc.data()).toList();

      // Fetch user profiles for each post
      for (final post in fetchedPosts) {
        if (post['userId'] != null) {
          final userId = post['userId'] as String;

          // Check if we already have this user's profile in cache
          if (!_userProfileCache.containsKey(userId)) {
            try {
              final userDoc =
                  await _firestore.collection('users').doc(userId).get();
              if (userDoc.exists) {
                _userProfileCache[userId] =
                    UserProfileModel.fromFirebase(userDoc);
              }
            } catch (e) {
              print('Error fetching user profile: $e');
            }
          }

          // Add the user profile to the post data
          if (_userProfileCache.containsKey(userId)) {
            post['userProfile'] = _userProfileCache[userId];
          }
        }
      }

      posts.value = fetchedPosts;
    });
  }

  void addPost(String content) {
    profileController.loadUserData();

    if (content.isNotEmpty) {
      String filteredText = SafeText.filterText(
        text: content,
        useDefaultWords: true,
        extraWords: [
          'plm',
          'fut',
          'cur',
          'pula',
          'coaie',
          'fututi',
          'pizda',
          'futu-ti',
          'futu-ti',
          'mortii',
          'matii',
          'futu-ti',
          'ma-tii',
          'ma-ta',
          'mata',
          'cacat',
          'coi',
          'cretin',
          'retardat',
          'prost',
          'idiot',
          'cretin',
          'tampit',
          'dobitoc',
          'bou',
          'vaca',
          'retardat',
          'handicapat',
          'nebun',
          'fraier',
          'porc',
          'scarbos',
          'jegos',
          'puturos',
          'miserupist',
          'nesimtit',
          'mincinos',
          'ipocrit',
          'jeg',
          'gunoi',
          'murdar',
          'obraznic',
          'prostovan',
          'imbecil',
          'sarlatan',
          'excroc',
          'nesimtire',
          'hoti',
          'parazit',
          'ratat',
          'bulangiu',
          'homalau',
          'futincurist',
          'olog',
        ],
        fullMode: true,
        obscureSymbol: "*",
      );

      // Get the user ID from the userController
      final userId = userController.user.value?.uid;

      _firestore.collection('posts').add({
        'content': filteredText,
        'timestamp': FieldValue.serverTimestamp(),
        'name': profileController.userProfile.value?.name ?? '',
        'userId': userId, // Store the user ID with the post
      });

      // Add the current user's profile to the cache
      if (userId != null && profileController.userProfile.value != null) {
        _userProfileCache[userId] = profileController.userProfile.value!;
      }

      postController.clear();
    }
  }
}
