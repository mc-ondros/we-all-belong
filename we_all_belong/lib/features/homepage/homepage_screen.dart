import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/components/homepage/rounded_rectangle_with_shadow.dart';
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
          backgroundColor: const Color(0xFFF5F5DC),
          title: const Text('Nearby Venues'),
        ),
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFf8e4c4),
          currentIndex: homepageController.selectedIndex.value,
          onTap: (value) {
            debugPrint('Bottom nav bar');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nearby'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            // Add other navigation items here
          ],
        ),
      ),
    );
  }
}
