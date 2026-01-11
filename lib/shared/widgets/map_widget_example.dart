// Example usage of MapWidget
// This file demonstrates how to use the MapWidget in your app

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_widget.dart';

/// Example 1: Basic map with current location
class BasicMapExample extends StatelessWidget {
  const BasicMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Map')),
      body: const MapWidget(
        height: 400,
        autoGetCurrentLocation: true,
        showMyLocation: true,
      ),
    );
  }
}

/// Example 2: Map with custom location and markers
class CustomMapExample extends StatefulWidget {
  const CustomMapExample({super.key});

  @override
  State<CustomMapExample> createState() => _CustomMapExampleState();
}

class _CustomMapExampleState extends State<CustomMapExample> {
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _addSampleMarkers();
  }

  void _addSampleMarkers() {
    setState(() {
      _markers.addAll([
        Marker(
          markerId: const MarkerId('marker1'),
          position: const LatLng(28.6139, 77.2090), // New Delhi
          infoWindow: const InfoWindow(title: 'New Delhi', snippet: 'Capital of India'),
        ),
        Marker(
          markerId: const MarkerId('marker2'),
          position: const LatLng(19.0760, 72.8777), // Mumbai
          infoWindow: const InfoWindow(title: 'Mumbai', snippet: 'Financial Capital'),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Map with Markers')),
      body: MapWidget(
        latitude: 28.6139,
        longitude: 77.2090,
        zoom: 6.0,
        markers: _markers,
        height: 400,
        onMapTap: (LatLng position) {
          // Add marker on tap
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('marker_${_markers.length + 1}'),
                position: position,
                infoWindow: InfoWindow(
                  title: 'New Marker',
                  snippet: '${position.latitude}, ${position.longitude}',
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

/// Example 3: Map with location selection
class LocationSelectionExample extends StatefulWidget {
  const LocationSelectionExample({super.key});

  @override
  State<LocationSelectionExample> createState() => _LocationSelectionExampleState();
}

class _LocationSelectionExampleState extends State<LocationSelectionExample> {
  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Column(
        children: [
          Expanded(
            child: MapWidget(
              height: double.infinity,
              autoGetCurrentLocation: true,
              markers: _selectedLocation != null
                  ? [
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation!,
                        infoWindow: InfoWindow(
                          title: 'Selected Location',
                          snippet: _selectedAddress ?? 'Loading address...',
                        ),
                      ),
                    ]
                  : null,
              onMapTap: (LatLng position) async {
                setState(() {
                  _selectedLocation = position;
                });
                // Get address for selected location
                // You can use MapService here
              },
              onMapLongPress: (LatLng position) {
                // Handle long press
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Long pressed at: ${position.latitude}, ${position.longitude}',
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedLocation != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Location:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Latitude: ${_selectedLocation!.latitude}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Longitude: ${_selectedLocation!.longitude}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_selectedAddress != null)
                    Text(
                      'Address: $_selectedAddress',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Example 4: Map with traffic layer
class TrafficMapExample extends StatelessWidget {
  const TrafficMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traffic Map')),
      body: const MapWidget(
        height: 400,
        enableTrafficLayer: true,
        autoGetCurrentLocation: true,
        mapType: MapType.normal,
      ),
    );
  }
}

/// Example 5: Map with satellite view
class SatelliteMapExample extends StatelessWidget {
  const SatelliteMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Satellite Map')),
      body: const MapWidget(
        height: 400,
        latitude: 28.6139,
        longitude: 77.2090,
        zoom: 15.0,
        mapType: MapType.satellite,
      ),
    );
  }
}

