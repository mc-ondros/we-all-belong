import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/core/core_shared.dart';
import 'package:we_all_belong/features/best_rated/best_rated.dart';
import 'package:we_all_belong/features/bottom_navigation_bar/bottom_navigation_controller.dart';
import 'package:we_all_belong/features/profile/screens/edit_profile_screen.dart';

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
    EditProfileScreen(), // Replace with your actual screen// Replace with your actual screen
  ];

  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: screens[bottomNavigationController.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: GenericColors.background,
          currentIndex: bottomNavigationController.selectedIndex.value,
          onTap: (value) {
            bottomNavigationController.selectedIndex.value = value; // Navigate to the selected screen
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Best Rated'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Nearby'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
