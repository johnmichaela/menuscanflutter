import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location permissions are granted
  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  // Get current location
  Future<Position> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();
    
    if (!hasPermission) {
      throw Exception('Location permission not granted');
    }
    
    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }
}