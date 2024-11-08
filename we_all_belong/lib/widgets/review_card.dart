// lib/widgets/review_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.userId, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RatingBarIndicator(
              rating: review.overallRating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingBarIndicator(
                  rating: review.lgbtqiaRating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star_half,
                    color: Colors.pink,
                  ),
                  itemCount: 5,
                  itemSize: 16.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 4),
                const Text('LGBTQIA+ Friendly'),
              ],
            ),
            Row(
              children: [
                RatingBarIndicator(
                  rating: review.pocRating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star_half,
                    color: Colors.orange,
                  ),
                  itemCount: 5,
                  itemSize: 16.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 4),
                const Text('POC Friendly'),
              ],
            ),
            Row(
              children: [
                RatingBarIndicator(
                  rating: review.halalRating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star_half,
                    color: Colors.green,
                  ),
                  itemCount: 5,
                  itemSize: 16.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 4),
                const Text('Halal Friendly'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}