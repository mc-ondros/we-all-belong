import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/features/homepage/controller/homepage_controller.dart';
import 'package:we_all_belong/components/generic_dropdown_controller.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';

import '../../components/generic_dropdown.dart';
import '../../components/specs/font_sizes.dart';
import '../../core/core_shared.dart';
import '../../core/google_maps_api/controller/location_controller.dart';

import '../../components/specs/colors.dart';

class MapPage extends StatelessWidget {
  final LocationController locationController = Get.find();
  final HomePageController homePageController = Get.find();
  final MyDropdownController myDropdownController = Get.put(MyDropdownController());

  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 135,
          automaticallyImplyLeading: false,
          backgroundColor: GenericColors.background,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: homePageController.venues.isNotEmpty,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: GenericColors.grey,
                      ),
                      gradient: const RadialGradient(
                          colors: [GenericColors.darkGrey, GenericColors.supportGrey],
                          center: Alignment.center,
                          radius: 5.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Select Category',
                        style: GoogleFonts.candal(
                          textStyle: const TextStyle(
                            color: GenericColors.white,
                            fontSize: FontSizes.f_18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        width: 145,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: GenericColors.grey,
                          ),
                          gradient: const RadialGradient(
                              colors: [GenericColors.highlightBlue, GenericColors.white],
                              center: Alignment.bottomCenter,
                              radius: 5.0),
                        ),
                        child: DropdownButtonCustom(
                          defaultValue: myDropdownController.selectedValue.value,
                          dropdownColor: GenericColors.background,
                          currentData: const [
                            'bar',
                            'restaurant',
                            'cafe',
                            'gym',
                            'library',
                            'movie_theater',
                            'night_club',
                            'museum',
                          ],
                          valueBuilder: (newValue) async {
                            myDropdownController.selectedValue.value = newValue;
                            homePageController.venues.value = await GoogleMapsApi().getNearbyVenues(
                                locationController.latitude.value,
                                locationController.longitude.value,
                                1500,
                                myDropdownController.selectedValue.value);
                            homePageController.updateMarkers();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      body: Obx(
        () => Visibility(
          visible: !homePageController.isUpdatingMarkers.value,
          replacement: const LoadingIndicator(
            indicatorType: Indicator.ballBeat,
            colors: [Colors.white],
          ),
          child: FlutterMap(
            options: MapOptions(
              initialZoom: 16.0,
              backgroundColor: Colors.black,
              initialCenter: LatLng(locationController.latitude.value, locationController.longitude.value),
            ),
            children: [
              TileLayer(
                retinaMode: true,
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: homePageController.markers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
