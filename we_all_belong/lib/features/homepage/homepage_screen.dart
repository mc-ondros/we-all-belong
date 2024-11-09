import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/components/generic_dropdown_controller.dart';
import 'package:we_all_belong/components/homepage/rounded_rectangle_with_shadow.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:we_all_belong/features/homepage/controller/homepage_controller.dart';
import 'package:we_all_belong/features/profile/profile_screen.dart';

import '../../components/generic_dropdown.dart';
import '../../core/core_shared.dart';
import '../../core/google_maps_api/controller/location_controller.dart';

class HomePage extends StatelessWidget {
  // Initialize the VenueController
  final HomePageController homepageController = Get.put(HomePageController());
  final MyDropdownController myDropdownController = Get.put(MyDropdownController());
  final LocationController locationController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      init: homepageController,
      builder: (_) => Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF5F5DC),
            title: Visibility(
              visible: homepageController.venues.isNotEmpty,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: 145,
                    height: 70,
                    child: DropdownButtonCustom(
                      borderColor: const Color(0xFFF5F5DC),
                      defaultValue: myDropdownController.selectedValue.value,
                      dropdownColor: Colors.transparent,
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
                        homepageController.venues.value = await GoogleMapsApi().getNearbyVenues(
                            locationController.latitude.value,
                            locationController.longitude.value,
                            1500,
                            myDropdownController.selectedValue.value);
                      },
                    ),
                  ),
                  const Text('Nearby:'),
                ],
              ),
            )),
        body: Scaffold(
          backgroundColor: const Color(0xFFF5F5DC),
          body: Obx(() => Visibility(
                replacement: const LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                ),
                visible: homepageController.venues.isNotEmpty,
                child: ListView.builder(
                  itemCount: homepageController.venues.length,
                  itemBuilder: (context, index) {
                    final venue = homepageController.venues[index];
                    return RoundedRectangleWithShadow(
                        color: const Color(0xFFF5F5DC),
                        borderColor: const Color(0xFF004225),
                        width: 792,
                        height: 100,
                        venue: venue,
                        onTap: () {
                          debugPrint('TODO: Go to Preview Venue');
                        });
                  },
                ),
              )),
        ),
      ),
    );
  }
}
