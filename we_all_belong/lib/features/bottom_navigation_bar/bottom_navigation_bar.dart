import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/core/core_shared.dart';
import 'package:we_all_belong/features/best_rated/best_rated.dart';
import 'package:we_all_belong/features/bottom_navigation_bar/bottom_navigation_controller.dart';
import 'package:we_all_belong/features/profile/screens/edit_profile_screen.dart';
import 'package:we_all_belong/features/wall/view/wall_view.dart';
import 'package:we_all_belong/features/map/map_view.dart';

import '../homepage/homepage_screen.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  State<BottomNavigationBarCustom> createState() => _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  final List<Widget> screens = [
    BestRatedScreen(),
    HomePage(),
    MapPage(),
    EditProfileScreen(),
    WallPage(), // Replace with your actual screen// Replace with your actual screen
  ];

  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[bottomNavigationController.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: GenericColors.white,
          unselectedItemColor: GenericColors.lighterGrey,
          backgroundColor: GenericColors.background,
          currentIndex: bottomNavigationController.selectedIndex.value,
          onTap: (value) {
            bottomNavigationController.selectedIndex.value = value; // Navigate to the selected screen
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'Best Rated'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              label: 'Nearby',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.post_add,
                  color: Colors.white,
                ),
                label: 'Wall'),
          ],
        ),
      ),
    );
  }
}
