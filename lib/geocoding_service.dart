import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  final String apiKey =
      'AIzaSyAK8SwgDEk6vd5K764aiLAtOSQDlU5WZKU'; // Reemplaza con tu clave de API

  Future<LatLng?> getCoordinates(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null;
  }
}
