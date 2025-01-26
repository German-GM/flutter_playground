import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenPos extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenPos> {
  late GoogleMapController _controller;

  final LatLng _initialPosition = LatLng(19.6900, -103.3350); // San Francisco

  final List<LatLng> _coordinates = [
    LatLng(19.6900, -103.3350), // Ejemplo: El Grullo, Jalisco
    LatLng(19.6905, -103.3355),
    LatLng(19.6910, -103.3360),
    LatLng(19.6915, -103.3365),
    LatLng(19.6920, -103.3370),
  ];

  Set<Marker> _createMarkers() {
    return _coordinates
        .asMap()
        .entries
        .map(
          (entry) => Marker(
            markerId: MarkerId('marker_${entry.key}'),
            position: entry.value,
            infoWindow: InfoWindow(title: 'Marker ${entry.key + 1}'),
          ),
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 17,
        ),
        markers: _createMarkers(),
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
