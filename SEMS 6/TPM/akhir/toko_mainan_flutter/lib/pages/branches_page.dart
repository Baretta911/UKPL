import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:toko_mainan_flutter/config/constants.dart'; // For TOMTOM_API_KEY

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  // TODO: Define store locations
  // final List<Map<String, dynamic>> storeLocations = [
  //   {'name': 'Toko Mainan Yogyakarta', 'lat': -7.7956, 'lng': 110.3695, 'city': 'Yogyakarta'},
  //   {'name': 'Toko Mainan Jakarta', 'lat': -6.2088, 'lng': 106.8456, 'city': 'Jakarta'},
  //   // Add WIT, WITA, London, Jepang, US locations
  // ];

  // TODO: Implement TomTom map and markers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Store Branches'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 50, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(
                'Find our store locations here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                '(LBS Integration with TomTom Maps - Coming Soon!)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      // TODO: Replace Center widget with FlutterMap integration
      // body: FlutterMap(
      //   options: MapOptions(
      //     center: LatLng(-6.2088, 106.8456), // Default to Jakarta or user's location
      //     zoom: 5.0,
      //   ),
      //   children: [
      //     TileLayer(
      //       urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"{z}/"{x}/"{y}.png?key=$TOMTOM_API_KEY",
      //       userAgentPackageName: 'com.example.toko_mainan_flutter',
      //       // TODO: Add markers for storeLocations
      //     ),
      //   ],
      // ),
    );
  }
}
