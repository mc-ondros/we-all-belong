import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:we_all_belong/features/preview_venue/controller/preview_venue_controller.dart';
import '../../components/specs/colors.dart';

class PreviewVenue extends StatefulWidget {
  final String? name;
  final String? id;
  final bool? open_now;
  const PreviewVenue({required this.name, required this.id, required this.open_now, super.key});

  @override
  State<PreviewVenue> createState() => _PreviewVenueState();
}

final PreviewVenueController previewVenueController = Get.put(PreviewVenueController());

class _PreviewVenueState extends State<PreviewVenue> {
  @override
  Widget build(BuildContext context) {
    var _isToggled = false;
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
            Text(
              'open now: ${widget.open_now}', //TODO: Add not sure option
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: GenericColors.shadyGreen)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'Accesibility for disabled:',
                            style: GoogleFonts.candal(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.add_circle,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              previewVenueController.rating.value = rating;
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'LGBTQIA+ friendliness:',
                            style: GoogleFonts.candal(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.add_circle,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              previewVenueController.rating.value = rating;
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Halal food available:',
                          style: GoogleFonts.candal(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Switch(
                            value: _isToggled,
                            onChanged: (value) {
                              setState(() {
                                _isToggled = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Kosher food available:',
                          style: GoogleFonts.candal(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Switch(
                          value: _isToggled,
                          onChanged: (value) {
                            setState(() {
                              _isToggled = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
