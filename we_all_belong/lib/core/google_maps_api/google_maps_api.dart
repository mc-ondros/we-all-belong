// ignore_for_file: avoid_print

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
    try {
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
    } catch (e) {
      print('error while getting photo: $e');
      return '';
    }
  }

  String _getPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey';
  }

  Future<List<VenueModel>> fetchPlacesFromCollection() async {
    try {
      // Step 1: Reference the Firestore collection and fetch all documents
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('venues');
      QuerySnapshot snapshot = await collectionRef.get();
      print('1');

      // Step 2: Initialize a list to store place details
      List<VenueModel> placeDetailsList = [];

      // Step 3: Loop through each document in the collection
      for (var doc in snapshot.docs) {
        // Extract the 'name' from each document
        String placeName = doc.id;
        // Step 4: Call the Google Places API for each name
        var response = await http.get(
          Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeName&key=$apiKey'),
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print('ok');
          printLongString(data.toString());
          print('4');
          placeDetailsList.add(VenueModel(
            name: data['result']['name'],
            vicinity: data['result']['formatted_address'],
            icon: data['result']['icon'],
            place_id: doc.id,
            open_now: data.toString().contains('open_now') ? data['result']['current_opening_hours']['open_now'] : true,
          ));
          print('5');
        } else {
          print("Failed to fetch place details for $placeName");
        }
      }

      // Return the list of place details
      return placeDetailsList;
    } catch (e) {
      throw Exception("Failed to fetch places: $e");
    }
  }
}
