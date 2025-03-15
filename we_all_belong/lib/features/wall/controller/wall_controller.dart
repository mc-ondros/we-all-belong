import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_text/safe_text.dart';
import 'package:we_all_belong/features/profile/controller/profile_controller.dart';

import '../../../core/user_controller/user_controller.dart';

class WallController extends GetxController {
  ProfileController profileController = ProfileController().initialized
      ? Get.find()
      : Get.put(ProfileController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserController userController = Get.find();
  var posts = <Map<String, dynamic>>[].obs;
  TextEditingController postController = TextEditingController();
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
        .listen((snapshot) {
      print(snapshot.docs[0].data().toString());
      posts.value = snapshot.docs.map((doc) => doc.data()).toList();
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
      _firestore.collection('posts').add({
        'content': filteredText,
        'timestamp': FieldValue.serverTimestamp(),
        'name': profileController.userProfile.value?.name ?? '',
        ''
      });
      postController.clear();
    }
  }
}
