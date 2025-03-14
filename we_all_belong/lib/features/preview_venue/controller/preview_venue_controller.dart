import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PreviewVenueController extends GetxController {
  RxDouble accesibilityRating = 3.0.obs;
  RxDouble lgbtRating = 3.0.obs;
  RxBool halalToggle = false.obs;
  RxBool kosherToggle = false.obs;
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;
  set imageFile(File? value) => _imageFile.value = value;

  RxString downloadURL = ''.obs;
  final RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  set isUploading(bool value) => _isUploading.value = value;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print('Image selected: ${imageFile!.path}');
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      print('No image selected.');
      return;
    }

    isUploading = true;

    try {
      String fileName = basename(imageFile!.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      downloadURL.value = await taskSnapshot.ref.getDownloadURL();

      isUploading = false;

      print('Download URL: $downloadURL');
    } catch (e, s) {
      isUploading = false;
      print('Error uploading image: $e $s');
    }
  }
}
