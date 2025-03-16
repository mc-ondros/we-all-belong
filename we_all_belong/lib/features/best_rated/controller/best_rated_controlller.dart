// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';

import '../../../core/models/venue_model.dart';
import '../../preview_venue/api/preview_venue_api.dart';

class BestRatedController extends GetxController {
  // Observable list to hold venues data
  var venues = <VenueModel>[].obs;
  RxList<(VenueModel, double)> tempVenueAndScore = <(VenueModel, double)>[].obs;
  RxList<(VenueModel, double)> venueAndScore = <(VenueModel, double)>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await fetchAllVenues();
    await _loadVenuesWithScores();
  }

  // Method to fetch all venues and update the list
  Future<void> fetchAllVenues() async {
    try {
      List<VenueModel> fetchedVenues = await GoogleMapsApi().fetchPlacesFromCollection();
      venues.value = fetchedVenues; // Update observable list
    } catch (e) {
      print("Failed to fetch venues: $e");
    }
  }

  Future<void> _loadVenuesWithScores() async {
    for (VenueModel venue in venues) {
      double score = 0;
      // Await the API response before proceeding
      List<ReviewModel> currentReviews = await PreviewVenueApi().fetchReviews(venue.place_id ?? '');

      for (ReviewModel review in currentReviews) {
        if (review.halal) {
          score++;
        }
        if (review.kosher) {
          score++;
        }
        if (review.accessibility >= 3) {
          score++;
        } else {
          score--;
        }
        if (review.friendliness >= 3) {
          score++;
        } else {
          score--;
        }
      }
      if (score / currentReviews.length > 3) {
        tempVenueAndScore.add((venue, score));
      }
    }

    // Sort the list based on scores in descending order
    tempVenueAndScore.sort((a, b) => b.$2.compareTo(a.$2));
    // Update state with sorted list

    venueAndScore = tempVenueAndScore;
    venueAndScore.sort((a, b) => b.$2.compareTo(a.$2));
    venues.value = venueAndScore.map((tuple) => tuple.$1).toList();
  }
}
