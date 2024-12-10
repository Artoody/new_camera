import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'bluetooth_connect_page.dart'; // For sending data via Bluetooth

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentLocation; // User's current location
  LatLng? _destination; // Selected destination
  List<LatLng> _routePoints = []; // Points along the route
  String? _currentTurnDirection; // Current turn direction (L or R)

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation(); // Fetch location when the page loads
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> _getDirections() async {
    if (_currentLocation == null || _destination == null) return;

    final url =
        'https://router.project-osrm.org/route/v1/driving/${_currentLocation!.longitude},${_currentLocation!.latitude};${_destination!.longitude},${_destination!.latitude}?geometries=geojson&steps=true';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coordinates =
          data['routes'][0]['geometry']['coordinates']; // Extract route points
      final List steps =
          data['routes'][0]['legs'][0]['steps']; // Navigation steps

      setState(() {
        _routePoints = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList(); // Convert to LatLng
      });

      _sendTurnByTurnDirections(steps);
    } else {
      print('Failed to fetch directions');
    }
  }

  void _sendTurnByTurnDirections(List steps) {
    for (final step in steps) {
      String turnDirection = step['maneuver']['modifier'] ?? 'straight';
      if (turnDirection.contains('left')) {
        _currentTurnDirection = 'L';
      } else if (turnDirection.contains('right')) {
        _currentTurnDirection = 'R';
      } else {
        _currentTurnDirection = 'S';
      }

      Provider.of<BluetoothConnectionStatus>(context, listen: false)
          .sendData(_currentTurnDirection!);

      Future.delayed(Duration(seconds: 3));
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _destination = latLng;
    });
    _getDirections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation!,
                initialZoom: 13.0,
                onTap: (tapPosition, latLng) => _onMapTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        child: Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                if (_destination != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _destination!,
                        child: Icon(
                          Icons.flag,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
