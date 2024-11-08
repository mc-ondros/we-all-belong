// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class ApiService {
  static const String _baseUrl = 'https://your-api-endpoint.com';

  static Future<List<Place>> fetchPlaces() async {
    final response = await http.get(Uri.parse('$_baseUrl/places'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  // Implement other API methods like search, add review, etc.
}