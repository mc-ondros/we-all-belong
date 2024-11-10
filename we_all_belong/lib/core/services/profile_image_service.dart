import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ProfileImageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      
      // Cache the image locally
      await _cacheImageLocally(url, userId);
      
      return url;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> _cacheImageLocally(String url, String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile_$userId.jpg');
    
    if (!await file.exists()) {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
    }
  }

  Future<String?> getCachedImagePath() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile_$userId.jpg');
    
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }
} 