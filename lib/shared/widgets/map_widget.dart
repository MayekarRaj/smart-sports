import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/config/map_config.dart';
import '../../core/services/map_service.dart';

/// Reusable Google Maps widget for the Smart Sports app
class MapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final List<Marker>? markers;
  final bool showMyLocation;
  final bool showMyLocationButton;
  final bool enableZoomControls;
  final bool enableTrafficLayer;
  final bool enableBuildings;
  final Function(LatLng)? onMapTap;
  final Function(CameraPosition)? onCameraMove;
  final Function(CameraPosition)? onCameraIdle;
  final Function(LatLng)? onMapLongPress;
  final MapType mapType;
  final double? height;
  final double? width;
  final bool autoGetCurrentLocation;
  final VoidCallback? onLocationError;

  const MapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom,
    this.markers,
    this.showMyLocation = true,
    this.showMyLocationButton = true,
    this.enableZoomControls = true,
    this.enableTrafficLayer = false,
    this.enableBuildings = true,
    this.onMapTap,
    this.onCameraMove,
    this.onCameraIdle,
    this.onMapLongPress,
    this.mapType = MapType.normal,
    this.height,
    this.width,
    this.autoGetCurrentLocation = false,
    this.onLocationError,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  final MapService _mapService = MapService();
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  Set<Marker> _markers = {};
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    if (widget.autoGetCurrentLocation) {
      await _getCurrentLocation();
    } else {
      _setInitialCameraPosition();
    }

    if (widget.markers != null) {
      _markers = Set<Marker>.from(widget.markers!);
    }
  }

  void _setInitialCameraPosition() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget.latitude ?? MapConfig.defaultLatitude,
        widget.longitude ?? MapConfig.defaultLongitude,
      ),
      zoom: widget.zoom ?? MapConfig.defaultZoom,
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position? position = await _mapService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _initialCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: widget.zoom ?? MapConfig.defaultZoom,
          );
        });
      } else {
        // Fallback to default location
        _setInitialCameraPosition();
        if (widget.onLocationError != null) {
          widget.onLocationError!();
        }
      }
    } catch (e) {
      print('Error getting current location: $e');
      _setInitialCameraPosition();
      if (widget.onLocationError != null) {
        widget.onLocationError!();
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // Set map style if needed (optional)
    // await _setMapStyle();

    // If auto-get location is enabled and we haven't got it yet, get it now
    if (widget.autoGetCurrentLocation && _currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition != null && _mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
        );
      }
    }
  }


  Future<void> moveToLocation(double latitude, double longitude,
      {double? zoom}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude, longitude),
          zoom ?? MapConfig.defaultZoom,
        ),
      );
    }
  }

  Future<void> moveToCurrentLocation() async {
    if (_currentPosition != null) {
      await moveToLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    } else {
      await _getCurrentLocation();
      if (_currentPosition != null) {
        await moveToLocation(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    }
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markers != oldWidget.markers) {
      setState(() {
        _markers = widget.markers != null
            ? Set<Marker>.from(widget.markers!)
            : <Marker>{};
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!MapConfig.isApiKeyConfigured) {
      return _buildApiKeyWarning();
    }

    if (_isLoadingLocation && widget.autoGetCurrentLocation) {
      return _buildLoadingWidget();
    }

    if (_initialCameraPosition == null) {
      return _buildLoadingWidget();
    }

    Widget mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialCameraPosition!,
      markers: _markers,
      myLocationEnabled: widget.showMyLocation,
      myLocationButtonEnabled: widget.showMyLocationButton,
      zoomControlsEnabled: widget.enableZoomControls,
      trafficEnabled: widget.enableTrafficLayer,
      buildingsEnabled: widget.enableBuildings,
      mapType: widget.mapType,
      compassEnabled: MapConfig.enableCompass,
      onTap: widget.onMapTap,
      onCameraMove: widget.onCameraMove != null
          ? (position) => widget.onCameraMove!(position)
          : null,
      onCameraIdle: widget.onCameraIdle != null
          ? () {
              if (_mapController != null && widget.onCameraIdle != null) {
                _mapController!.getVisibleRegion().then((bounds) {
                  // Camera idle callback
                });
              }
            }
          : null,
      onLongPress: widget.onMapLongPress,
    );

    if (widget.height != null || widget.width != null) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: mapWidget,
      );
    }

    return mapWidget;
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: widget.height ?? 300,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildApiKeyWarning() {
    return Container(
      height: widget.height ?? 300,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Google Maps API Key Not Configured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Please configure your Google Maps API key in:\nlib/core/config/map_config.dart',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Open documentation or config file
                },
                child: const Text('View Setup Instructions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

