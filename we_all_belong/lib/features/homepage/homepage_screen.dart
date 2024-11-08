import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/features/homepage/controller/homepage_controller.dart';

import '../../core/core_shared.dart';

class HomePage extends StatelessWidget {
  // Initialize the VenueController
  final HomePageController homepageController = Get.put(HomePageController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(
      init: homepageController,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Venues'),
        ),
        body: Obx(() => Visibility(
              replacement: LoadingIndicator(
                indicatorType: Indicator.ballPulse,
              ),
              visible: homepageController.venues.isNotEmpty,
              child: ListView.builder(
                itemCount: homepageController.venues.length,
                itemBuilder: (context, index) {
                  final venue = homepageController.venues[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Image.network(
                        venue.icon ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(venue.name ?? ''),
                      subtitle: Text(venue.vicinity ?? ''),
                      onTap: () {
                        // Handle tap if you want to navigate to details page
                      },
                    ),
                  );
                },
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homepageController.selectedIndex.value,
          onTap: (value) {
            print('Bottom nav bar');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            // Add other navigation items here
          ],
        ),
      ),
    );
  }
}
