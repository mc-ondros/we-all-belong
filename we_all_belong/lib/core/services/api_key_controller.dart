// ignore_for_file: avoid_print

import 'package:we_all_belong/core/core_shared.dart';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';

class ApiKeyController extends GetxController {
  var apiKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApiKey();
  }

  Future<void> fetchApiKey() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('config').doc('api_keys').get();
      if (snapshot.exists && snapshot.data() != null) {
        apiKey.value = snapshot.get('google_maps_api');
      } else {
        throw Exception("API key not found in Firestore");
      }
    } catch (e) {
      print("Error fetching API key: $e");
    }
  }
}

class GoogleMapsApi {
  final ApiKeyController apiKeyController = Get.put(ApiKeyController());

  Future<List<VenueModel>> getNearbyVenues(double latitude, double longitude, int radius, String type) async {
    String apiKey = apiKeyController.apiKey.value;
    if (apiKey.isEmpty) {
      await apiKeyController.fetchApiKey();
      apiKey = apiKeyController.apiKey.value;
    }
    debugPrint('Fetching Venues');

    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby?key=$apiKey',
    );

    final body = json.encode({
      "includedTypes": [type],
      "maxResultCount": 20,
      "locationRestriction": {
        "circle": {
          "center": {"latitude": latitude, "longitude": longitude},
          "radius": radius
        }
      }
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-FieldMask':
            'places.displayName,places.id,places.formattedAddress,places.iconMaskBaseUri,places.currentOpeningHours.openNow'
      },
      body: body,
    );

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final venuesList = data['places'] as List;
        debugPrint('Found ${venuesList.length} venues');

        return venuesList.map((venue) {
          return VenueModel(
            name: venue['displayName']['text'] ?? 'Unknown',
            vicinity: venue['formattedAddress'] ?? 'Unknown',
            icon: venue['iconMaskBaseUri'] ?? '',
            place_id: venue['id'] ?? '',
            open_now: venue.containsKey('currentOpeningHours') && venue['currentOpeningHours']['openNow'] == true,
          );
        }).toList();
      } else {
        throw Exception('Failed to retrieve venues: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<String?> getPlacePhotoUrl(String placeId) async {
    String apiKey = apiKeyController.apiKey.value;
    if (apiKey.isEmpty) {
      await apiKeyController.fetchApiKey();
      apiKey = apiKeyController.apiKey.value;
    }

    try {
      final url = Uri.parse('https://places.googleapis.com/v1/places/$placeId?fields=photos&key=$apiKey');
      final response = await http.get(url, headers: {'X-Goog-FieldMask': 'photos'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          final photoReference = data['photos'][0]['name'];
          return _getPhotoUrl(photoReference);
        }
      }
      return '';
    } catch (e) {
      print('Error while getting photo: $e');
      return '';
    }
  }

  String _getPhotoUrl(String photoReference) {
    String apiKey = apiKeyController.apiKey.value;
    return 'https://places.googleapis.com/v1/$photoReference/media?maxWidthPx=400&key=$apiKey';
  }

  Future<List<VenueModel>> fetchPlacesFromCollection() async {
    String apiKey = apiKeyController.apiKey.value;
    if (apiKey.isEmpty) {
      await apiKeyController.fetchApiKey();
      apiKey = apiKeyController.apiKey.value;
    }

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('venues');
      QuerySnapshot snapshot = await collectionRef.get();

      List<VenueModel> placeDetailsList = [];

      for (var doc in snapshot.docs) {
        String placeId = doc.id;
        var response = await http.get(Uri.parse('https://places.googleapis.com/v1/places/$placeId?key=$apiKey'),
            headers: {'X-Goog-FieldMask': 'displayName,formattedAddress,iconMaskBaseUri,currentOpeningHours.openNow'});

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          placeDetailsList.add(VenueModel(
            name: data['displayName']['text'] ?? 'Unknown',
            vicinity: data['formattedAddress'] ?? 'Unknown',
            icon: data['iconMaskBaseUri'] ?? '',
            place_id: placeId,
            open_now: data.containsKey('currentOpeningHours') && data['currentOpeningHours']['openNow'] == true,
          ));
        } else {
          print("Failed to fetch place details for $placeId");
        }
      }

      return placeDetailsList;
    } catch (e) {
      throw Exception("Failed to fetch places: $e");
    }
  }
}
