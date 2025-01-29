import "dart:async";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geocoding_service.dart';

class MapScreenAddress extends StatefulWidget {
  const MapScreenAddress({super.key});

  @override
  State<MapScreenAddress> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenAddress> {
  final Completer<GoogleMapController> googleMapController = Completer();
  final GeocodingService _geocodingService = GeocodingService();

  final List<String> _addresses = [
    // '1600 Amphitheatre Parkway, Mountain View, CA',
    // '1 Infinite Loop, Cupertino, CA',
    // '350 5th Ave, New York, NY',
    'Urbano Rosales 139 El Grullo, Jalisco',
    'Manuel Doblado B 21 El Grullo, Jalisco',
  ];

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    for (var i = 0; i < _addresses.length; i++) {
      final LatLng? coordinates =
          await _geocodingService.getCoordinates(_addresses[i]);
      if (coordinates != null) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('marker_$i'),
              position: coordinates,
              infoWindow: InfoWindow(title: 'Marker ${i + 1}'),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Addresses'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(19.8019412, -104.2098175), // San Francisco
          zoom: 18,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
      ),
    );
  }
}
