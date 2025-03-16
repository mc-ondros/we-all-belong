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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize the VenueController
  final HomePageController homepageController = Get.find();

  final MyDropdownController myDropdownController = Get.put(MyDropdownController());

  final LocationController locationController = Get.find();
  @override
  void initState() {
    super.initState();
    myDropdownController.selectedValue.value.toLowerCase().replaceAll(' ', '_');
  }

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
                    margin: const EdgeInsets.all(65.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: GenericColors.primaryAccent,
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
                          style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                              color: GenericColors.moonGrey,
                              fontSize: FontSizes.f_15,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: 150,
                          height: 60,
                          child: DropdownButtonCustom(
                            defaultValue: myDropdownController.selectedValue.value,
                            dropdownColor: GenericColors.moonGrey,
                            currentData: const [
                              'Bar',
                              'Restaurant',
                              'Cafe',
                              'Gym',
                              'Library',
                              'Movie Theater',
                              'Night Club',
                              'Museum',
                            ],
                            valueBuilder: (newValue) async {
                              myDropdownController.selectedValue.value = newValue;
                              homepageController.venues.value = await GoogleMapsApi().getNearbyVenues(
                                  locationController.latitude.value,
                                  locationController.longitude.value,
                                  1500,
                                  myDropdownController.selectedValue.value.toLowerCase().replaceAll(' ', '_'));
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
          backgroundColor: GenericColors.background,
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
                          Get.to(
                            PreviewVenue(
                              name: venue.name,
                              id: venue.place_id,
                              open_now: venue.open_now,
                              venueModel: venue,
                            ),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        });
                  },
                ),
              )),
        ),
      ),
    );
  }
}
