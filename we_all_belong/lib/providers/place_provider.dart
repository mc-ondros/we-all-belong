// lib/providers/place_provider.dart
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/api_service.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places => _places;

  Future<void> fetchPlaces() async {
    _places = await ApiService.fetchPlaces();
    notifyListeners();
  }

  // Implement search and filter methods as needed
}