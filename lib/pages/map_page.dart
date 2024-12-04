import 'package:final_year_project/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final List<Restaurant> restaurants;
  final LocationData? userLocation;
  const MapPage({
    super.key,
    required this.restaurants,
    required this.userLocation,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    markers.add(
      Marker(
        point: LatLng(
          widget.userLocation?.latitude ?? 33.878085,
          widget.userLocation?.longitude ?? 35.534605,
        ),
        child: const Icon(
          Icons.circle,
          color: Colors.blue,
          size: 15,
        ),
      ),
    );

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
          initialCenter: LatLng(
            widget.userLocation?.latitude ?? 33.8938,
            widget.userLocation?.longitude ?? 35.5018,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.final_year_project',
          ),
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
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1,
                        decoration: TextDecoration.none,
                      ),
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
