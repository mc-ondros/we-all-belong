import 'package:we_all_belong/core/core_shared.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';
import 'package:we_all_belong/features/homepage/homepage_screen.dart';

class KYCController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var nationality = ''.obs;
  var gender = ''.obs;
  var religiousOrientation = ''.obs;
  var sexualPreference = ''.obs;
  var disabilities = <String>[].obs;
  
  final availableDisabilities = [
    'Physical',
    'Sensorial',
    'Intellectual',
    'Learning',
    'Emotional'
  ];

  Future<void> submitKYCData() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final user = _auth.currentUser;
      if (user == null) return;

      final userProfile = UserProfileModel(
        uuid: user.uid,
        email: user.email!,
        name: user.displayName,
        nationality: nationality.value,
        gender: gender.value,
        religiousOrientation: religiousOrientation.value,
        sexualPreference: sexualPreference.value,
        disabilities: disabilities,
        isOnboarded: true,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson(), SetOptions(merge: true));

      Get.back(); // Dismiss loading
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.back(); // Dismiss loading
      Get.snackbar(
        'Error',
        'Failed to save profile data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 