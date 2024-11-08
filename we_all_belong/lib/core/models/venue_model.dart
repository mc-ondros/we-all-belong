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
  // final List<ReviewModel>? reviewList;

  VenueModel({
    this.name,
    this.vicinity,
    this.icon,
    // this.reviewList,
  });

  // Factory method to create a Venue object from JSON
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      name: json['venueName'] as String,
      vicinity: json['address'] as String,
      icon: json['imageLink'] as String,
      // reviewList: (json['reviewList'] as List).map((review) => ReviewModel.fromJson(review)).toList(),
    );
  }

  // Convert a Venue object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vicinity': vicinity,
      'icon': icon,
      // 'reviewList': reviewList?.map((review) => review.toJson()).toList(),
    };
  }
}
