import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/core/google_maps_api/controller/location_controller.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:we_all_belong/core/models/venue_model.dart';
import 'package:we_all_belong/features/preview_venue/preview_venue.dart';
import 'package:we_all_belong/features/profile/screens/edit_profile_screen.dart';
import 'package:latlong2/latlong.dart';

import '../../../components/specs/colors.dart';
import '../../../core/core_shared.dart';

class HomePageController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  RxList<VenueModel> venues = <VenueModel>[].obs;
  RxInt selectedIndex = 0.obs;
  RxList<Marker> markers = <Marker>[].obs;

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
    markers.value = venues.map<Marker>((place) {
      final lat = place.lat;
      final lng = place.long;
      return Marker(
        width: 100,
        height: 100,
        point: LatLng(lat ?? 0.0, lng ?? 0.0),
        child: GestureDetector(
          onTap: () {
            Get.to(PreviewVenue(
                name: venues.firstWhere((element) => element.lat == lat && element.long == lng).name,
                id: venues.firstWhere((element) => element.lat == lat && element.long == lng).place_id,
                open_now: venues.firstWhere((element) => element.lat == lat && element.long == lng).open_now));
            // Handle marker tap
          },
          child: Column(
            children: [
              Icon(
                Icons.location_pin,
                color: GenericColors.highlightBlue,
                size: 60,
              ),
              Text(
                venues.firstWhere((element) => element.lat == lat && element.long == lng).name ?? '',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
