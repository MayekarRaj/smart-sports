# Google Maps API Integration Summary

## ✅ What Has Been Added

### 1. **Packages Added** (`pubspec.yaml`)
- `google_maps_flutter: ^2.5.0` - Google Maps Flutter plugin
- `geolocator: ^13.0.1` - Location services
- `geocoding: ^3.0.0` - Address geocoding

### 2. **Configuration Files**
- `lib/core/config/map_config.dart` - Map configuration and API key settings
- `MAP_API_SETUP.md` - Complete setup guide

### 3. **Services**
- `lib/core/services/map_service.dart` - Location and geocoding service

### 4. **Widgets**
- `lib/shared/widgets/map_widget.dart` - Reusable Google Maps widget
- `lib/shared/widgets/map_widget_example.dart` - Usage examples

### 5. **Platform Configuration**
- **Android**: Updated `AndroidManifest.xml` with location permissions and API key meta-data
- **iOS**: Updated `Info.plist` with location permissions and `AppDelegate.swift` with Google Maps initialization

## 📝 Next Steps

### Step 1: Configure API Keys
You need to add your Google Maps API key in **3 places**:

1. **Android**: `android/app/src/main/AndroidManifest.xml`
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY"/>
   ```

2. **iOS**: `ios/Runner/AppDelegate.swift`
   ```swift
   GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY")
   ```

3. **Flutter**: `lib/core/config/map_config.dart`
   ```dart
   static const String googleMapsApiKey = 'YOUR_ACTUAL_API_KEY';
   ```

### Step 2: Get Your API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create/select a project
3. Enable **Maps SDK for Android** and **Maps SDK for iOS**
4. Create an API key in **APIs & Services** > **Credentials**
5. Copy and paste it in the 3 locations above

See `MAP_API_SETUP.md` for detailed instructions.

## 🚀 Usage Examples

### Replace Existing Map Placeholders

#### Example: In `add_booking_screen.dart`

**Before:**
```dart
Widget _buildMapView() {
  return Container(
    height: 200,
    child: Image.asset('assets/images/map.png'), // Placeholder
  );
}
```

**After:**
```dart
import 'package:smart_sports/shared/widgets/map_widget.dart';

Widget _buildMapView() {
  return MapWidget(
    height: 200,
    autoGetCurrentLocation: true,
    showMyLocation: true,
    onMapTap: (LatLng position) {
      // Handle map tap
    },
  );
}
```

#### Example: In `member_registration_page.dart`

**Before:**
```dart
Widget _buildMapView() {
  return Container(
    height: 300,
    child: Center(
      child: Icon(Icons.map, size: 48),
    ),
  );
}
```

**After:**
```dart
import 'package:smart_sports/shared/widgets/map_widget.dart';

Widget _buildMapView() {
  return MapWidget(
    height: 300,
    autoGetCurrentLocation: true,
    showMyLocation: true,
  );
}
```

### Using Map Service

```dart
import 'package:smart_sports/core/services/map_service.dart';

final mapService = MapService();

// Get current location
final position = await mapService.getCurrentPosition();
if (position != null) {
  print('Lat: ${position.latitude}, Lon: ${position.longitude}');
}

// Convert coordinates to address
final address = await mapService.coordinatesToAddress(
  position.latitude,
  position.longitude,
);

// Calculate distance between two points
final distance = mapService.calculateDistance(
  lat1, lon1, lat2, lon2,
);
```

## 📍 Common Use Cases

### 1. Show Current Location
```dart
MapWidget(
  autoGetCurrentLocation: true,
  showMyLocation: true,
  height: 300,
)
```

### 2. Show Specific Location with Markers
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

### 3. Location Selection
```dart
MapWidget(
  onMapTap: (LatLng position) {
    // Save selected location
    setState(() {
      selectedLocation = position;
    });
  },
)
```

### 4. Show Multiple Club Locations
```dart
MapWidget(
  markers: clubs.map((club) => Marker(
    markerId: MarkerId(club.id),
    position: LatLng(club.latitude, club.longitude),
    infoWindow: InfoWindow(title: club.name),
  )).toList(),
)
```

## 🔧 Available Map Widget Properties

- `latitude` / `longitude` - Initial map center
- `zoom` - Initial zoom level
- `markers` - List of markers to display
- `showMyLocation` - Show user's current location
- `showMyLocationButton` - Show location button
- `autoGetCurrentLocation` - Automatically get and center on user location
- `enableTrafficLayer` - Show traffic information
- `enableBuildings` - Show 3D buildings
- `mapType` - Map type (normal, satellite, hybrid, terrain)
- `onMapTap` - Callback when map is tapped
- `onMapLongPress` - Callback when map is long-pressed
- `height` / `width` - Widget dimensions

## 📱 Files That Can Use Maps

You can replace map placeholders in these files:

1. `lib/bookings/screens/add_booking_screen.dart` - `_buildMapView()`
2. `lib/auth/screens/member_registration_page.dart` - `_buildMapView()`
3. `lib/role_specific/club/screens/courts/courts_page.dart` - `_buildMapSection()`
4. `lib/role_specific/coach/screens/clubs/coach_page.dart` - `MobileMapSection`
5. `lib/role_specific/club/screens/clubs/clubs_page.dart` - `MobileMapSection`
6. Any other screen that shows location/club information

## ⚠️ Important Notes

1. **API Key Security**: Never commit API keys to version control. Consider using environment variables for production.

2. **Permissions**: The app will automatically request location permissions when needed. Handle permission denials gracefully.

3. **Billing**: Google Maps requires a billing account, but provides free credits monthly.

4. **Testing**: Test on both Android and iOS devices, as location permissions work differently on each platform.

## 🐛 Troubleshooting

- **Maps not showing**: Check API key is set in all 3 locations
- **Location not working**: Check permissions are granted
- **Build errors**: Run `flutter clean` and `flutter pub get`

For more details, see `MAP_API_SETUP.md`.

