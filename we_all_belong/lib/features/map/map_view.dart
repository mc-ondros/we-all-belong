import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:we_all_belong/features/homepage/controller/homepage_controller.dart';

import '../../components/specs/colors.dart';
import '../../core/google_maps_api/controller/location_controller.dart';

class MapPage extends StatelessWidget {
  final LocationController locationController = Get.find();
  final HomePageController homePageController = Get.find();
  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GenericColors.background,
        title: const Text(
          'Map View',
          style: TextStyle(
            color: GenericColors.secondaryAccent,
          ),
        ),
      ),
      body: Obx(
        () => FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(locationController.latitude.value, locationController.longitude.value),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: homePageController.markers,
            ),
          ],
        ),
      ),
    );
  }
}
