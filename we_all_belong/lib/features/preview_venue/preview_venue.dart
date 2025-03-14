// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_all_belong/core/google_maps_api/google_maps_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:we_all_belong/core/models/venue_model.dart';
import 'package:we_all_belong/features/preview_venue/api/preview_venue_api.dart';
import 'package:we_all_belong/features/preview_venue/controller/preview_venue_controller.dart';
import '../../components/specs/colors.dart';
import '../../core/user_controller/user_controller.dart';

class PreviewVenue extends StatefulWidget {
  final String? name;
  final String? id;
  final bool? open_now;

  const PreviewVenue({required this.name, required this.id, required this.open_now, super.key});

  @override
  State<PreviewVenue> createState() => _PreviewVenueState();
}

class _PreviewVenueState extends State<PreviewVenue> {
  late Future<List<ReviewModel>> _reviewsFuture;
  final ScrollController _scrollController = ScrollController();
  double _imageOpacity = 1.0; // Initial opacity (fully visible)
  final UserController userController = Get.find();
  final PreviewVenueController previewVenueController = Get.put(PreviewVenueController());
  final TextEditingController reviewTextEditingController = TextEditingController();
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    _reviewsFuture = PreviewVenueApi().fetchReviews(widget.id ?? '');

    // Listen to scroll changes and adjust opacity
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double newOpacity = (200 - offset) / 200;
      newOpacity = newOpacity.clamp(0.0, 1.0);

      if (newOpacity != _imageOpacity) {
        setState(() {
          _imageOpacity = newOpacity;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    reviewTextEditingController.dispose();
    super.dispose();
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
          style: GoogleFonts.outfit(
            fontSize: 20,
            color: GenericColors.primaryAccent,
            fontWeight: FontWeight.bold,

          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: FutureBuilder<String?>(
                    future: GoogleMapsApi().getPlacePhotoUrl(widget.id ?? ''),
                    builder: (context, snapshot) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _imageOpacity,
                        child: SizedBox(
                          width: 500,
                          height: 500,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: snapshot.hasData && snapshot.data!.isNotEmpty
                                ? Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Text(
                                  'No Photos',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildReviewSection(),
              const SizedBox(height: 20),
              _buildReviewsList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingRow('Accessibility for disabled:', (rating) {
            previewVenueController.accesibilityRating.value = rating;
          }),
          _buildRatingRow('Nush cplm sa mai adaug aici:', (rating) {
            previewVenueController.accesibilityRating.value = rating;
          }),
          const SizedBox(height: 10),
          _buildRatingRow('LGBTQIA+ friendliness:', (rating) {
            previewVenueController.lgbtRating.value = rating;
          }),
          const SizedBox(height: 10),
          _buildToggleRow('Halal food available:', previewVenueController.halalToggle),
          const SizedBox(height: 10),
          _buildToggleRow('Kosher food available:', previewVenueController.kosherToggle),
          const SizedBox(height: 20),
          TextField(
            controller: reviewTextEditingController,
            decoration: InputDecoration(
              hintText: 'Write your opinion...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await PreviewVenueApi().uploadReview(
                ReviewModel(
                  uuid: userController.userModel.value.uuid ?? '',
                  text: reviewTextEditingController.text,
                  accessibility: previewVenueController.accesibilityRating.value,
                  friendliness: previewVenueController.lgbtRating.value,
                  halal: previewVenueController.halalToggle.value,
                  kosher: previewVenueController.kosherToggle.value,
                ),
                widget.id ?? '',
              );
              setState(() {
                reviews.add(ReviewModel(
                  uuid: 'uuid',
                  text: reviewTextEditingController.text,
                  accessibility: previewVenueController.accesibilityRating.value,
                  friendliness: previewVenueController.lgbtRating.value,
                  halal: previewVenueController.halalToggle.value,
                  kosher: previewVenueController.kosherToggle.value,
                ));
                reviewTextEditingController.clear();
              });
            },
            child: const Text("Post Review"),
          ),
        ],
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
          return Center(child: Text("Error fetching reviews: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reviews available"));
        } else {
          reviews = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListTile(
                title: Text(review.text),
                subtitle: Text("Accessibility: ${review.accessibility}"),
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
        Text(label),
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: onRatingUpdate,
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, RxBool toggle) {
    return Row(children: [Text(label), Obx(() => Switch(value: toggle.value, onChanged: (value) => toggle.value = value))]);
  }
}
