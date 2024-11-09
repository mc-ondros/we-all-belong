import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';

import '../../components/specs/colors.dart';

class PreviewVenue extends StatefulWidget {
  final String? name;
  final String? id;
  const PreviewVenue({required this.name, required this.id, super.key});

  @override
  State<PreviewVenue> createState() => _PreviewVenueState();
}

class _PreviewVenueState extends State<PreviewVenue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GenericColors.backgroundCrem,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.name ?? '',
          style: GoogleFonts.candal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: GenericColors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FutureBuilder<String?>(
                  future: GoogleMapsApi().getPlacePhotoUrl(widget.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.data != '' && snapshot.hasData) {
                      return SizedBox(
                        width: 300,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            snapshot.data ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (snapshot.data == '') {
                      return Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'No Photos',
                            style: GoogleFonts.candal(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'info about this place: ',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
