// Map Configuration for Smart Sports App
// This file contains Google Maps API configuration

class MapConfig {
  // Google Maps API Key
  // TODO: Replace with your actual Google Maps API key
  // Get your API key from: https://console.cloud.google.com/google/maps-apis
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  // Default map settings
  static const double defaultLatitude = 28.6139; // Default: New Delhi, India
  static const double defaultLongitude = 77.2090;
  static const double defaultZoom = 12.0;

  // Map style settings
  static const bool enableTrafficLayer = false;
  static const bool enableBuildings = true;
  static const bool enableMyLocationButton = true;
  static const bool enableMyLocation = true;
  static const bool enableCompass = true;
  static const bool enableZoomControls = true;

  // Location settings
  static const double locationAccuracy = 10.0; // meters
  static const Duration locationTimeout = Duration(seconds: 10);
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  // Map marker settings
  static const double defaultMarkerSize = 1.0;
  static const String defaultMarkerColor = '#FF0000'; // Red

  // Check if API key is configured
  static bool get isApiKeyConfigured =>
      googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY_HERE' &&
      googleMapsApiKey.isNotEmpty;
}

