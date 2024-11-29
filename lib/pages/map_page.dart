import 'dart:developer';

import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  Location location = Location();
  LocationData? _locationData;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  final List<Marker> _markers = [];
  final _restaurantService = RestaurantService();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _fetchRestaurants();
  }

  Future<void> _initializeLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData != null) {
      setState(
        () {
          mapController.move(
            LatLng(_locationData!.latitude ?? 33.8938,
                _locationData!.longitude ?? 35.5018),
            14.0,
          );
        },
      );
    }
  }

  void _fetchRestaurants() async {
    try {
      final restaurants = await _restaurantService.getRestaurants();
      setState(
        () {
          _markers.add(
            const Marker(
              point: LatLng(33.878085, 35.534605),
              child: Icon(
                Icons.circle,
                color: Colors.blue,
                size: 15,
              ),
            ),
          );
          _markers.addAll(
            restaurants.map(
              (restaurant) => Marker(
                point: LatLng(restaurant.latitude, restaurant.longitude),
                width: 200,
                height: 100,
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (error) {
      log("Error fetching restaurants: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialZoom: 12,
              initialCenter: LatLng(33.8938, 35.5018),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.final_year_project',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
