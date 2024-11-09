// ignore_for_file: non_constant_identifier_names

class ReviewModel {
  final String uuid;
  final String text;

  ReviewModel({required this.uuid, required this.text});

  // Factory method to create a Review object from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      uuid: json['uuid'] as String,
      text: json['text'] as String,
    );
  }

  // Convert a Review object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'text': text,
    };
  }
}

class VenueModel {
  final String? name;
  final String? vicinity;
  final String? icon;
  final String? place_id;
  // final List<ReviewModel>? reviewList;

  VenueModel({
    this.name,
    this.vicinity,
    this.icon,
    this.place_id,
    // this.reviewList,
  });

  // Factory method to create a Venue object from JSON
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      name: json['name'] as String,
      vicinity: json['vicinity'] as String,
      icon: json['icon'] as String,
      place_id: json['place_id'] as String,
      // reviewList: (json['reviewList'] as List).map((review) => ReviewModel.fromJson(review)).toList(),
    );
  }

  // Convert a Venue object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vicinity': vicinity,
      'icon': icon,
      'place_id': place_id,
      // 'reviewList': reviewList?.map((review) => review.toJson()).toList(),
    };
  }
}
