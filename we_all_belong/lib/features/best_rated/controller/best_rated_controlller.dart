// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';

import '../../../core/models/venue_model.dart';

class BestRatedController extends GetxController {
  // Observable list to hold venues data
  var venues = <VenueModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllVenues();
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
}
