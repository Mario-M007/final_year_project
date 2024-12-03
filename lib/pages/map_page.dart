import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/notification/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final List<Restaurant> restaurants;
  const MapPage({super.key, required this.restaurants});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  Location location = Location();
  LocationData? _locationData;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  final List<Marker> markers = [];
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _addMarkers();
    _localNotificationService.initLocalNotification();
    _startLocationListener();
  }

  Future _initializeLocation() async {
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

    setState(() {
      _locationData = _locationData;
    });

    developer.log("$_locationData");

    if (_locationData != null) {
      mapController.move(
        LatLng(_locationData?.latitude ?? 33.8938,
            _locationData?.longitude ?? 35.5018),
        14.0,
      );
    }
  }

  void _addMarkers() async {
    try {
      developer.log("USER ADDING MARKER LOCATION $_locationData");
      // user location
      markers.add(
        Marker(
          point: LatLng(
            _locationData?.latitude ?? 33.878085,
            _locationData?.longitude ?? 35.534605,
          ),
          child: const Icon(
            Icons.circle,
            color: Colors.blue,
            size: 15,
          ),
        ),
      );
      // restaurants
      markers.addAll(
        widget.restaurants.map(
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
    } catch (error) {
      developer.log("Error adding markers: $error");
    }
  }

  final Map<String, bool> _notificationShown = {};
  final Map<String, DateTime> _lastNotificationTime = {};

  void _startLocationListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      for (var restaurant in widget.restaurants) {
        double distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude!,
          currentLocation.longitude!,
          restaurant.latitude,
          restaurant.longitude,
        );

        // Check if the user is within 100 meters of the restaurant and if a notification has not been shown yet
        if (distanceInMeters <= 100 &&
            (_notificationShown[restaurant.name] ?? false) == false) {
          DateTime now = DateTime.now();
          DateTime? lastNotification = _lastNotificationTime[restaurant.name];

          // Check if the last notification was shown more than 30 minutes ago
          if (lastNotification == null ||
              now.difference(lastNotification).inMinutes > 30) {
            // Show a local notification with a discount offer
            _localNotificationService.showNotification(
              id: Random().nextInt(1000),
              title: "MenuMate",
              body: "Enjoy a 20% discount only @ ${restaurant.name}",
            );
            // Mark the notification as shown and update the last notification time
            _notificationShown[restaurant.name] = true;
            _lastNotificationTime[restaurant.name] = now;
          }
        }
        // Reset the notification flag if the user is more than 100 meters away from the restaurant
        else if (distanceInMeters > 100) {
          _notificationShown[restaurant.name] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialZoom: 12,
          initialCenter: LatLng(_locationData?.latitude ?? 33.8938,
              _locationData?.longitude ?? 35.5018),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.final_year_project',
          ),
          // if (_showClusterLayer)
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              markers: markers,
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1,
                          decoration: TextDecoration.none),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
