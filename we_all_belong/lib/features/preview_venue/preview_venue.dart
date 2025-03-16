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
import 'package:maps_launcher/maps_launcher.dart';

// ignore: must_be_immutable
class PreviewVenue extends StatefulWidget {
  final String? name;
  final String? id;
  final VenueModel venueModel;
  final bool? open_now;
  UserController userController = Get.find();
  // ignore: prefer_typing_uninitialized_variables
  var reviews;
  final TextEditingController reviewTextEditingController = TextEditingController();
  PreviewVenue({required this.venueModel, this.name, required this.id, required this.open_now, super.key});

  @override
  State<PreviewVenue> createState() => _PreviewVenueState();
}

final PreviewVenueController previewVenueController = Get.put(PreviewVenueController());

class _PreviewVenueState extends State<PreviewVenue> {
  late Future<List<ReviewModel>> _reviewsFuture;
  double _imageOpacity = 1.0;
  double _appBarOpacity = 1.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _reviewsFuture = PreviewVenueApi().fetchReviews(widget.id ?? '');
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 50) {
      setState(() {
        _appBarOpacity = 0.0;
      });
    } else {
      setState(() {
        _appBarOpacity = 1.0;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll(double offset) {
    setState(() {
      _imageOpacity = (1 - (offset - 300)).clamp(0.0, 1.0);
      _appBarOpacity = (1 - (offset / 100)).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GenericColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          opacity: _appBarOpacity,
          duration: const Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.name ?? '',
              style: GoogleFonts.jost(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: GenericColors.almostWhite,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.green),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _onScroll(scrollNotification.metrics.pixels);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView(
            controller: ScrollController(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: FutureBuilder<String?>(
                    future: GoogleMapsApi().getPlacePhotoUrl(widget.id ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.data != '' && snapshot.hasData) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _imageOpacity,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                snapshot.data ?? '',
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image is fully loaded
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
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
                              style: GoogleFonts.jost(
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
                style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GenericColors.primaryAccent,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: widget.open_now ?? false,
                replacement: Text(
                  'Closed',
                  style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GenericColors.secondaryAccent,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                child: Text(
                  'Open now',
                  style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GenericColors.secondaryAccent,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10, left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    MapsLauncher.launchCoordinates(widget.venueModel.lat ?? 0.0, widget.venueModel.long ?? 0.0);
                  },
                  child: const Text("Get directions"),
                ),
              ),
              const SizedBox(height: 20),
              _buildReviewSection(),
              const SizedBox(height: 20),
              Text(
                "Reviews:",
                style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: GenericColors.almostWhite,
                  ),
                ),
              ),
              _buildReviewsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How is your experience?',
            style: GoogleFonts.jost(
              textStyle: const TextStyle(
                fontSize: 22,
                color: GenericColors.shadyGreen,
                fontWeight: FontWeight.w700,
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
          _buildToggleRow('Vegan food available:', previewVenueController.veganToggle),
          
          const SizedBox(height: 20),
          Text(
            'Write your review:',
            style: GoogleFonts.jost(
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
              fillColor: Colors.black,
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
            onTap: () async {
              await previewVenueController.pickImage(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (previewVenueController.imageFile != null) {
                await previewVenueController.uploadImage();
                debugPrint('downloadURL: ${previewVenueController.downloadURL.value}');
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
                  vegan: previewVenueController.veganToggle.value,
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
                  vegan: previewVenueController.veganToggle.value,
                  photoUrl: previewVenueController.downloadURL.value,
                ));
                widget.reviewTextEditingController.clear();
                previewVenueController.accesibilityRating.value = 3.0;
                previewVenueController.lgbtRating.value = 3.0;
                previewVenueController.halalToggle.value = false;
                previewVenueController.kosherToggle.value = false;
                previewVenueController.veganToggle.value = false;
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
          debugPrint("Error fetching reviews: ${snapshot.error}");
          return const LoadingIndicator(
            indicatorType: Indicator.ballBeat,
            colors: [Colors.white],
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            "No reviews available",
            style: GoogleFonts.jost(
              textStyle: const TextStyle(
                color: GenericColors.white,
                fontSize: 15,
              ),
            ),
          ));
        } else {
          widget.reviews = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: GenericColors.shadyGreen,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
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
                      Text("Vegan: ${review.vegan ? "Yes" : "No"}"),
                      Visibility(visible: review.photoUrl != '', child: const Text("User photo:")),
                      if (review.photoUrl != '')
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
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                debugPrint('$exception, photoURL: ${review.photoUrl} ${review.text}');
                                debugPrint(stackTrace.toString());
                                return Container();
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
          style: GoogleFonts.jost(
            textStyle: const TextStyle(
              color: GenericColors.almostWhite,
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
          style: GoogleFonts.jost(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GenericColors.almostWhite,
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
