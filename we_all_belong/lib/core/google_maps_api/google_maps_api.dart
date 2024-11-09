import 'package:we_all_belong/core/core_shared.dart';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';

class GoogleMapsApi {
  Future<List<VenueModel>> getNearbyVenues(double latitude, double longitude, int radius, String type) async {
    String apiKey = 'AIzaSyALygucmNuwO7TIlA6ZXPbWczDRlpylAgo';
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
}
