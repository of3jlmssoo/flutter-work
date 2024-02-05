import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  var _latitude;
  var _longitude;

  Future<void> getCurrentLocation() async {
    try {
      // somethingThatExpectsLessThan10(12);
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      debugPrint('-->' + position.toString());
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  get latitude => _latitude;
  get longitude => _longitude;
}
