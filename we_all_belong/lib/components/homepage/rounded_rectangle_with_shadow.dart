import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/core/models/venue_model.dart';
//import 'package:we_all_belong/core/styles/generic_colors.dart';
import '../../components/specs/colors.dart';

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
    debugPrint('venue icon: ${venue.icon}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: GenericColors.background,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: GenericColors.highlightBlue,
            width: 2,
          ),
        ),
        child: ListTile(
          leading: SvgPicture.network(
            fixVenues(venue.icon ?? ''),
            width: 50,
            height: 50,
            placeholderBuilder: (BuildContext context) => const LoadingIndicator(
              indicatorType: Indicator.ballBeat,
              colors: [Colors.white],
            ),
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
              );
            },
          ),
          title: Text(
            venue.name ?? '',
            style: const TextStyle(color: GenericColors.primaryAccent),
          ),
          subtitle: Text(
            venue.vicinity ?? '',
            style: const TextStyle(color: GenericColors.secondaryAccent),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

extension RoundedRectangleWithShadowExtension on RoundedRectangleWithShadow {
  String fixVenues(String originalString) {
    if (originalString.contains('bar')) {
      return 'https://www.svgrepo.com/show/444797/drink-cocktail.svg';
    } else if (originalString.contains('restaurant')) {
      return 'https://www.svgrepo.com/show/281640/restaurant-fork.svg';
    } else if (originalString.contains('cafe')) {
      return 'https://www.svgrepo.com/show/530227/coffee.svg';
    } else if (originalString.contains('gym')) {
      return 'https://www.svgrepo.com/show/475554/gym.svg';
    } else if (originalString.contains('library')) {
      return 'https://www.svgrepo.com/show/296928/library-book.svg';
    } else if (originalString.contains('museum')) {
      return 'https://www.svgrepo.com/show/293848/museum.svg';
    } else if (originalString.contains('movie_theater')) {
      return 'https://www.svgrepo.com/show/484557/popcorn.svg';
    } else if (originalString.contains('night_club')) {
      return 'https://www.svgrepo.com/show/268413/disco-club.svg';
    }
    return '';
  }
}
