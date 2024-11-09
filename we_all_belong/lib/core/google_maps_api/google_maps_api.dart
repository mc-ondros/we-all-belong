import 'package:we_all_belong/core/core_shared.dart';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';

class GoogleMapsApi {
  String apiKey = 'AIzaSyALygucmNuwO7TIlA6ZXPbWczDRlpylAgo';

  Future<List<VenueModel>> getNearbyVenues(double latitude, double longitude, int radius, String type) async {
    debugPrint('Fetching Venues');
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey');
    debugPrint('$latitude, $longitude, $radius');

    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final venuesList = data['results'] as List;
          debugPrint('Found ${venuesList.length} venues');
          List<VenueModel> venues = [];
          for (var venue in venuesList) {
            venues.add(VenueModel(
              name: venue['name'] as String,
              vicinity: venue['vicinity'] as String,
              icon: venue['icon'] as String,
              place_id: venue['place_id'] as String,
              open_now: venue['opening_hours'] != null ? venue['opening_hours']['open_now'] : false,
            ));
          }
          return venues;
        } else {
          throw Exception('Failed to retrieve venues: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load nearby venues');
      }
    } catch (e) {
      debugPrint('Error e: $e');
      return []; // Handle error by returning an empty list
    }
  }

  void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) => debugPrint(match.group(0)));
  }

  Future<String?> getPlacePhotoUrl(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=photos&key=$apiKey';
    // Added debug print

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Added debug print

      if (data['result']['photos'] != null && data['result']['photos'].isNotEmpty) {
        // Get the photo reference
        final photoReference = data['result']['photos'][0]['photo_reference'];
        // Fetch the photo using the photo reference
        return _getPhotoUrl(photoReference);
      } else {
        return '';
      }
    } else {
      return '';
// Added debug print
    }
  }

  String _getPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey';
  }
}
