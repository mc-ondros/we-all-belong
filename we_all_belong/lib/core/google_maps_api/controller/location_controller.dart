import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  @override
  void onInit() async {
    super.onInit();
    requestLocation();
  }

  Future<void> requestLocation() async {
    // Check location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position and update latitude and longitude
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }
}
