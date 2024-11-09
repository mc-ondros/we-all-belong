import 'package:flutter/material.dart';
import 'package:we_all_belong/core/models/venue_model.dart';

class RoundedRectangleWithShadow extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final double width;
  final double height;
  final double borderRadius;
  final double shadowOffset;
  final Color shadowColor;
  final double shadowBlurRadius;
  final VenueModel venue;
  final void Function()? onTap;
  const RoundedRectangleWithShadow({
    super.key,
    required this.color,
    required this.borderColor,
    required this.width,
    required this.height,
    required this.venue,
    required this.onTap,
    this.borderRadius = 30.0,
    this.shadowOffset = 5.0,
    this.shadowColor = Colors.black26,
    this.shadowBlurRadius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor, // Add border color here
            width: 2, // Optional border width
          ),
        ),
        child: ListTile(
          leading: Image.network(
            venue.icon ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(venue.name ?? ''),
          subtitle: Text(venue.vicinity ?? ''),
          onTap: () {
            onTap!();
          },
        ),
      ),
    );
  }
}
