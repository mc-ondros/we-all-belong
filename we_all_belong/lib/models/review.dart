// lib/models/review.dart
class Review {
  final String userId;
  final String comment;
  final double overallRating;
  final double lgbtqiaRating;
  final double pocRating;
  final double halalRating;
  final String imageUrl;

  Review({
    required this.userId,
    required this.comment,
    required this.overallRating,
    required this.lgbtqiaRating,
    required this.pocRating,
    required this.halalRating,
    required this.imageUrl,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      comment: json['comment'],
      overallRating: json['overallRating'].toDouble(),
      lgbtqiaRating: json['lgbtqiaRating'].toDouble(),
      pocRating: json['pocRating'].toDouble(),
      halalRating: json['halalRating'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}