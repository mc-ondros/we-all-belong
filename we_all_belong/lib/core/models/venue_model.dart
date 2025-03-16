// ignore_for_file: non_constant_identifier_names

class ReviewModel {
  final String uuid;
  final String text;
  final String photoUrl;
  final double accessibility;
  final double friendliness;
  final bool halal;
  final bool kosher;
  final bool vegan;

  ReviewModel({
    required this.uuid,
    required this.text,
    required this.photoUrl,
    required this.accessibility,
    required this.friendliness,
    required this.halal,
    required this.kosher,
    required this.vegan,
  });

  // Factory method to create a Review object from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      uuid: json['uuid'] as String,
      text: json['text'] as String,
      photoUrl: json['photoUrl'] ?? '',
      accessibility: (json['accessibility'] as num).toDouble(),
      friendliness: (json['friendliness'] as num).toDouble(),
      halal: json['halal'] as bool,
      kosher: json['kosher'] as bool,
      vegan: json['vegan'] as bool? ?? false, // Default to false for backward compatibility
    );
  }

  // Convert a Review object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'text': text,
      'photoUrl': photoUrl,
      'accessibility': accessibility,
      'friendliness': friendliness,
      'halal': halal,
      'kosher': kosher,
      'vegan': vegan,
    };
  }

  // Factory method to create a list of Review objects from JSON
  static List<ReviewModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
  }

  // Convert a list of Review objects to JSON
  static List<Map<String, dynamic>> toJsonList(List<ReviewModel> reviews) {
    return reviews.map((review) => review.toJson()).toList();
  }
}

class VenueModel {
  final String? name;
  final String? vicinity;
  final String? icon;
  final String? place_id;
  final bool? open_now;
  final double? lat;
  final double? long;

  VenueModel({
    this.name,
    this.vicinity,
    this.icon,
    this.place_id,
    this.open_now,
    this.lat,
    this.long,
  });

  // Factory method to create a Venue object from JSON
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      name: json['name'] as String,
      vicinity: json['vicinity'] as String,
      icon: json['icon'] as String,
      open_now: json['open_now'] as bool,
      place_id: json['place_id'] as String,
      lat: json['lat'] as double,
      long: json['long'] as double,
    );
  }

  // Convert a Venue object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vicinity': vicinity,
      'icon': icon,
      'place_id': place_id,
      'open_now': open_now,
      'lat': lat,
      'long': long,
    };
  }
}
