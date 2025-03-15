import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/components/generic_dropdown_controller.dart';
import 'package:we_all_belong/components/homepage/rounded_rectangle_with_shadow.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:we_all_belong/features/homepage/controller/homepage_controller.dart';

import '../../components/generic_dropdown.dart';
import '../../components/specs/font_sizes.dart';
import '../../core/core_shared.dart';
import '../../core/google_maps_api/controller/location_controller.dart';
import '../preview_venue/preview_venue.dart';

import '../../components/specs/colors.dart';

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
          toolbarHeight: 135,
            automaticallyImplyLeading: false,
            backgroundColor: GenericColors.background,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: homepageController.venues.isNotEmpty,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all()
                    ),
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
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: 145,
                          height: 70,
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
                              homepageController.venues.value = await GoogleMapsApi().getNearbyVenues(
                                  locationController.latitude.value,
                                  locationController.longitude.value,
                                  1500,
                                  myDropdownController.selectedValue.value);
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            )),
        body: Scaffold(
          backgroundColor: GenericColors.settingsGrey,
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
                        color: GenericColors.background,
                        borderColor: GenericColors.highlightBlue,
                        width: 792,
                        height: null,
                        venue: venue,
                        onTap: () {
                          Get.to(PreviewVenue(
                            name: venue.name,
                            id: venue.place_id,
                            open_now: venue.open_now,
                          ));
                        });
                  },
                ),
              )),
        ),
      ),
    );
  }
}
