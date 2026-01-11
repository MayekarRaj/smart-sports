# Google Maps API Setup Guide

This guide will help you set up Google Maps API for the Smart Sports application.

## Prerequisites

1. A Google Cloud Platform (GCP) account
2. A GCP project with billing enabled

## Step 1: Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API**
   - **Places API** (optional, for place search)

4. Go to **APIs & Services** > **Credentials**
5. Click **Create Credentials** > **API Key**
6. Copy your API key

## Step 2: Configure Android

1. Open `android/app/src/main/AndroidManifest.xml`
2. Find the meta-data tag with `com.google.android.geo.API_KEY`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE"/>
```

## Step 3: Configure iOS

1. Open `ios/Runner/AppDelegate.swift`
2. Find the line with `GMSServices.provideAPIKey`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
```

## Step 4: Configure Flutter App

1. Open `lib/core/config/map_config.dart`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:

```dart
static const String googleMapsApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

## Step 5: Install Dependencies

Run the following command to install the new packages:

```bash
flutter pub get
```

## Step 6: Platform-Specific Setup

### Android

1. Ensure your `minSdkVersion` is at least 21 (already configured)
2. The Google Maps API key is configured in `AndroidManifest.xml`

### iOS

1. Run `cd ios && pod install` to install iOS dependencies
2. Ensure your iOS deployment target is iOS 12.0 or higher
3. The Google Maps API key is configured in `AppDelegate.swift`

## Step 7: API Key Restrictions (Recommended)

For security, restrict your API key:

1. Go to **APIs & Services** > **Credentials** in Google Cloud Console
2. Click on your API key
3. Under **Application restrictions**:
   - For Android: Add your app's package name and SHA-1 certificate fingerprint
   - For iOS: Add your app's bundle identifier
4. Under **API restrictions**: Restrict to only the APIs you need

## Usage Examples

### Basic Map Widget

```dart
import 'package:smart_sports/shared/widgets/map_widget.dart';

MapWidget(
  height: 300,
  autoGetCurrentLocation: true,
  showMyLocation: true,
)
```

### Map with Custom Location

```dart
MapWidget(
  latitude: 28.6139,
  longitude: 77.2090,
  zoom: 15.0,
  markers: [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(28.6139, 77.2090),
      infoWindow: InfoWindow(title: 'New Delhi'),
    ),
  ],
)
```

### Using Map Service

```dart
import 'package:smart_sports/core/services/map_service.dart';

final mapService = MapService();

// Get current location
final position = await mapService.getCurrentPosition();

// Convert coordinates to address
final address = await mapService.coordinatesToAddress(
  position.latitude,
  position.longitude,
);

// Calculate distance
final distance = mapService.calculateDistance(
  lat1, lon1, lat2, lon2,
);
```

## Troubleshooting

### Maps not showing
- Verify API key is correctly set in all three locations
- Check that Maps SDK for Android/iOS is enabled in Google Cloud Console
- Ensure billing is enabled for your GCP project

### Location permissions
- The app will request location permissions automatically
- Users can deny permissions - handle this gracefully in your UI

### Build errors
- Run `flutter clean` and `flutter pub get`
- For iOS: Run `cd ios && pod install`
- For Android: Clean and rebuild the project

## Security Notes

- **Never commit API keys to version control**
- Use environment variables or secure storage for production
- Restrict API keys to specific apps and APIs
- Monitor API usage in Google Cloud Console

## Support

For more information, visit:
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)

