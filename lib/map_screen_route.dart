import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// Imports locales
// import 'package:playground/location_service.dart';
import 'package:playground/directions_service.dart';
import 'dart:async';

class MapScreenRoute extends StatefulWidget {
  const MapScreenRoute({super.key});

  @override
  State<MapScreenRoute> createState() => _MapScreenRouteState();
}

class _MapScreenRouteState extends State<MapScreenRoute> {
  Completer<GoogleMapController> googleMapController = Completer();
  LatLng currentLocation = LatLng(0, 0);
  List<LatLng> waypoints = [
    const LatLng(19.8086095, -104.2090753),
    const LatLng(19.7989683, -104.2171784),
    const LatLng(19.8100926, -104.2279121),
    const LatLng(19.8111307, -104.2228806),
  ];
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  Future<void> _loadMap() async {
    // Position position = await LocationService.getCurrentLocation();
    setState(() {
      currentLocation = LatLng(19.8060047180633,
          -104.21551678670274); // LatLng(position.latitude, position.longitude);
    });

    List<LatLng> route =
        await DirectionsService.getOptimalRoute(currentLocation, waypoints);
    setState(() {
      polylines.add(Polyline(
        polylineId: PolylineId("optimal_route"),
        points: route,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: currentLocation, zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
        markers: {
          Marker(markerId: MarkerId("current"), position: currentLocation),
          ...waypoints.map(
              (wp) => Marker(markerId: MarkerId(wp.toString()), position: wp))
        },
        polylines: polylines,
      ),
    );
  }
}
