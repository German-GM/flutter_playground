import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const String googleApiKey = "AIzaSyAK8SwgDEk6vd5K764aiLAtOSQDlU5WZKU";

class DirectionsService {
  static Future<List<LatLng>> getOptimalRoute(
      LatLng origin, List<LatLng> waypoints) async {
    String waypointsString =
        waypoints.map((wp) => "${wp.latitude},${wp.longitude}").join('|');

    String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${origin.latitude},${origin.longitude}"
        "&destination=${waypoints.last.latitude},${waypoints.last.longitude}"
        "&waypoints=optimize:true|$waypointsString"
        "&key=$googleApiKey";

    var response = await http.get(Uri.parse(url));
    var jsonData = json.decode(response.body);

    if (jsonData["status"] == "OK") {
      List<LatLng> polylineCoordinates = [];
      var steps = jsonData["routes"][0]["legs"];
      for (var leg in steps) {
        for (var step in leg["steps"]) {
          var polyline = step["polyline"]["points"];
          polylineCoordinates
              .addAll(PolylinePoints().decodePolyline(polyline).map(
                    (point) => LatLng(point.latitude, point.longitude),
                  ));
        }
      }
      return polylineCoordinates;
    } else {
      throw Exception("Error obteniendo la ruta: ${jsonData["status"]}");
    }
  }
}
