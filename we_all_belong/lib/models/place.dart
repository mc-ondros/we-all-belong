// lib/models/place.dart

import 'review.dart';

class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;
  final List<Review> reviews;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
      imageUrl: json['imageUrl'],
    );
  }
}