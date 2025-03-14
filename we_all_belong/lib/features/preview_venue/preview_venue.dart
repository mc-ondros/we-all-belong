// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:we_all_belong/core/models/venue_model.dart';
import 'package:we_all_belong/features/preview_venue/api/preview_venue_api.dart';
import 'package:we_all_belong/features/preview_venue/controller/preview_venue_controller.dart';
import '../../components/specs/colors.dart';
import '../../core/user_controller/user_controller.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PreviewVenue extends StatefulWidget {
  final String? name;
  final String? id;
  final bool? open_now;
  UserController userController = Get.find();
  // ignore: prefer_typing_uninitialized_variables
  var reviews;
  final TextEditingController reviewTextEditingController = TextEditingController();
  PreviewVenue({required this.name, required this.id, required this.open_now, super.key});

  @override
  State<PreviewVenue> createState() => _PreviewVenueState();
}

final PreviewVenueController previewVenueController = Get.put(PreviewVenueController());

class _PreviewVenueState extends State<PreviewVenue> {
  late Future<List<ReviewModel>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = PreviewVenueApi().fetchReviews(widget.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GenericColors.background,
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
        child: ListView(
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
              'Info about this place:',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GenericColors.primaryAccent,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Open now: ${widget.open_now}',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GenericColors.secondaryAccent,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildReviewSection(),
            const SizedBox(height: 20),
            Text(
              "Reviews:",
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildReviewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: GenericColors.shadyGreen)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How is your experience?',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildRatingRow('Accessibility for disabled:', (rating) {
              previewVenueController.accesibilityRating.value = rating;
            }),
            const SizedBox(height: 20),
            _buildRatingRow('LGBTQIA+ friendliness:', (rating) {
              previewVenueController.lgbtRating.value = rating;
            }),
            const SizedBox(height: 20),
            _buildToggleRow('Halal food available:', previewVenueController.halalToggle),
            const SizedBox(height: 20),
            _buildToggleRow('Kosher food available:', previewVenueController.kosherToggle),
            const SizedBox(height: 20),
            Text(
              'Write your review:',
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: widget.reviewTextEditingController,
              decoration: InputDecoration(
                hintText: 'Write your opinion...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                previewVenueController.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (previewVenueController.imageFile != null) {
                  await previewVenueController.uploadImage();
                } else {
                  previewVenueController.downloadURL.value = '';
                }
                await PreviewVenueApi().uploadReview(
                  ReviewModel(
                    uuid: widget.userController.userModel.value.uuid ?? '', //TODO: implement ID
                    text: widget.reviewTextEditingController.text,
                    accessibility: previewVenueController.accesibilityRating.value,
                    friendliness: previewVenueController.lgbtRating.value,
                    halal: previewVenueController.halalToggle.value,
                    kosher: previewVenueController.kosherToggle.value,
                    photoUrl: previewVenueController.downloadURL.value,
                  ),
                  widget.id ?? '',
                );
                setState(() {
                  widget.reviews ??= [];
                  widget.reviews.add(ReviewModel(
                    uuid: 'uuid',
                    text: widget.reviewTextEditingController.text,
                    accessibility: previewVenueController.accesibilityRating.value,
                    friendliness: previewVenueController.lgbtRating.value,
                    halal: previewVenueController.halalToggle.value,
                    kosher: previewVenueController.kosherToggle.value,
                    photoUrl: '',
                  ));
                  widget.reviewTextEditingController.clear();
                  previewVenueController.accesibilityRating.value = 3.0;
                  previewVenueController.lgbtRating.value = 3.0;
                  previewVenueController.halalToggle.value = false;
                  previewVenueController.kosherToggle.value = false;
                });
              },
              child: const Text("Post Review"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error fetching reviews: ${snapshot.error}");
          return LoadingIndicator(
            indicatorType: Indicator.ballBeat,
            colors: [Colors.white],
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reviews available"));
        } else {
          widget.reviews = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(review.text),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Accessibility:"),
                      RatingBarIndicator(
                        rating: review.accessibility,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),
                      const Text("Friendliness: "),
                      RatingBarIndicator(
                        rating: review.friendliness,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),
                      Text("Halal: ${review.halal ? "Yes" : "No"}"),
                      Text("Kosher: ${review.kosher ? "Yes" : "No"}"),
                      Text("User photo:"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            review.photoUrl,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRatingRow(String label, void Function(double) onRatingUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.candal(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.add_circle,
            color: Colors.amber,
          ),
          onRatingUpdate: onRatingUpdate,
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, RxBool toggle) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.candal(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => Switch(
            value: toggle.value,
            onChanged: (value) {
              setState(() {
                toggle.value = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
