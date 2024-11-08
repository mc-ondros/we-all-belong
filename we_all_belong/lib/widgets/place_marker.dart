// lib/widgets/place_marker.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class PlaceMarker extends Marker {
  PlaceMarker({required Place place, required VoidCallback onTap})
      : super(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(title: place.name),
          onTap: onTap,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
}