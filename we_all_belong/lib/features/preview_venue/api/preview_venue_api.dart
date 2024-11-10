// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/venue_model.dart';

class PreviewVenueApi {
  Future<void> uploadReview(ReviewModel review, String placeId) async {
    try {
      await FirebaseFirestore.instance.collection('venues').doc(placeId).set({
        "reviews": FieldValue.arrayUnion([review.toJson()])
      }, SetOptions(merge: true)); // Ensures the document is created if it doesn’t exist
      print("Review uploaded successfully.");
    } catch (e) {
      throw Exception("Failed to upload review. $e");
    }
  }

  Future<List<ReviewModel>> fetchReviews(String placeId) async {
    try {
      DocumentSnapshot placeSnapshot = await FirebaseFirestore.instance.collection('venues').doc(placeId).get();

      if (placeSnapshot.exists) {
        List<dynamic> reviewList = placeSnapshot.get("reviews") ?? [];
        return reviewList.map((review) => ReviewModel.fromJson(review as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch reviews.");
    }
  }
}
