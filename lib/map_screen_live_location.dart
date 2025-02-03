import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

class MapScreenLiveLocation extends StatefulWidget {
  const MapScreenLiveLocation({super.key});

  @override
  State<MapScreenLiveLocation> createState() => _MapScreenLiveLocationState();
}

class _MapScreenLiveLocationState extends State<MapScreenLiveLocation> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  double? _currentHeading;
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startCompass();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    // Carga el ícono personalizado desde los assets
    _customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(64, 64)), // Tamaño del ícono
      'images/marker_live.png', // Ruta del ícono
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Obtén la ubicación actual con alta precisión
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high, // Alta precisión
      ),
    );

    setState(() {
      _currentPosition = position;
    });

    // Configura los ajustes de ubicación
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Actualiza cada 5 metros
    );

    // Escucha los cambios en la ubicación
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        setState(() {
          _currentPosition = position;
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      },
    );
  }

  void _startCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _currentHeading = event.heading; // Actualiza la orientación
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación en Tiempo Real'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 18, // Zoom más cercano para mayor precisión
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  rotation:
                      _currentHeading ?? 0, // Rota el marcador según la brújula
                  anchor: Offset(0.5, 0.5),
                  icon:
                      _customIcon!, /*BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),*/
                ),
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              compassEnabled: false,
            ),
    );
  }
}
