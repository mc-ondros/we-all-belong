import 'package:get/get.dart';
import 'package:we_all_belong/core/google_maps_api/controller/location_controller.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:we_all_belong/core/models/venue_model.dart';
import 'package:we_all_belong/features/profile/screens/edit_profile_screen.dart';

class HomePageController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  RxList<VenueModel> venues = <VenueModel>[].obs;
  RxInt selectedIndex = 0.obs;

  void onTabTapped(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        // Home tab - just update the index since we're already on home
        break;
      case 1:
        // Profile tab
        Get.to(() => EditProfileScreen());
        break;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    while (locationController.latitude.value == 0.0) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    venues.value = await GoogleMapsApi()
        .getNearbyVenues(locationController.latitude.value, locationController.longitude.value, 1500, 'bar');
    GoogleMapsApi().printLongString(venues[0].toJson().toString());
  }
}
