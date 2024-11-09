// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/venue_model.dart';

class PreviewVenueApi {
  Future<void> uploadReview(ReviewModel review, String place_id) async {
    try {
      await FirebaseFirestore.instance.collection('venues').doc(place_id).update({
        "reviews": FieldValue.arrayUnion([review.toJson()])
      });
    } catch (e) {
      throw Exception("Failed to upload review.");
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
