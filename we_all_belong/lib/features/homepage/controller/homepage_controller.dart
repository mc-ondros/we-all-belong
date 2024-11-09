import 'package:get/get.dart';
import 'package:we_all_belong/core/google_maps_api/controller/location_controller.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:we_all_belong/core/models/venue_model.dart';

class HomePageController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  RxList<VenueModel> venues = <VenueModel>[].obs;
  RxInt selectedIndex = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    while (locationController.latitude.value == 0.0) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    venues.value = await GoogleMapsApi()
        .getNearbyVenues(locationController.latitude.value, locationController.longitude.value, 500, 'bar');
    GoogleMapsApi().printLongString(venues[0].toJson().toString());
  }
}
