import 'package:get/get.dart';

import '../models/user_profile_model.dart';

class UserController extends GetxController {
  Rx<UserProfileModel> userModel = UserProfileModel(email: '', uuid: '').obs;
}
