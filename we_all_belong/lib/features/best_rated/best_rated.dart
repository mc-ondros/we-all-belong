import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/components/homepage/rounded_rectangle_with_shadow.dart';
import '../../components/specs/colors.dart';
import '../preview_venue/preview_venue.dart';
import '../../components/specs/font_sizes.dart';
import 'controller/best_rated_controlller.dart';

class BestRatedScreen extends StatelessWidget {
  // Initialize the HomePageController
  final BestRatedController bestRatedController = Get.put(BestRatedController());
  BestRatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<BestRatedController>(
      init: bestRatedController,
      builder: (_) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: GenericColors.background,
          title: Visibility(
            visible: bestRatedController.venues.isNotEmpty,
            child: Text(
              'Best rated:',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: FontSizes.f_18,
                ),
              ),
            ),
          ),
        ),
        body: Scaffold(
          backgroundColor: GenericColors.background,
          body: Obx(() => Visibility(
                replacement: const Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Colors.white],
                  ),
                ),
                visible: bestRatedController.venues.isNotEmpty,
                child: ListView.builder(
                  itemCount: bestRatedController.venues.length,
                  itemBuilder: (context, index) {
                    final venue = bestRatedController.venues[index];
                    return RoundedRectangleWithShadow(
                      color: const Color(0xFFF5F5DC),
                      borderColor: const Color(0xFF004225),
                      width: 792,
                      height: null,
                      venue: venue,
                      onTap: () {
                        Get.to(() => PreviewVenue(
                              name: venue.name,
                              id: venue.place_id,
                              open_now: venue.open_now ?? false,
                            ));
                      },
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
