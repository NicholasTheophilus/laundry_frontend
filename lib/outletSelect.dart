import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class Outlet {
  final int id;
  final String name;
  final String location;
  final String open;
  final String phone;
  double distance;
  final String imageUrl;

  Outlet({
    required this.id, 
    required this.name,
    required this.location,
    required this.open,
    required this.phone,
    required this.distance,
    required this.imageUrl,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      open: json['open'] as String,
      phone: json['phone'] as String,
      distance: json['distance'] == null ? 0.0 : json['distance'].toDouble(),
      imageUrl: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'open': open,
      'phone': phone,
      'distance': distance,
      'imageUrl': imageUrl,
    };
  }
}

class OutletSelectPage extends StatefulWidget {
  @override
  _OutletSelectPageState createState() => _OutletSelectPageState();
}

class _OutletSelectPageState extends State<OutletSelectPage> {
  List<Outlet> outlets = [];
  String searchQuery = '';


  Future<double> calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) / 1000; // Convert to kilometers
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _calculateDistances() async {
    try {
      Position currentPosition = await getCurrentLocation();
      double currentLatitude = currentPosition.latitude;
      double currentLongitude = currentPosition.longitude;

      for (var outlet in outlets) {
        // Anggap bahwa lokasi outlet diberikan dalam format "latitude,longitude"
        List<String> locationParts = outlet.location.split(',');
        double outletLatitude = double.parse(locationParts[0]);
        double outletLongitude = double.parse(locationParts[1]);

        double distance = await calculateDistance(currentLatitude, currentLongitude, outletLatitude, outletLongitude);
        setState(() {
          outlet.distance = distance;
        });
      }
    } catch (e) {
      print('Error calculating distances: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOutlets().then((fetchedOutlets) {
      setState(() {
        outlets = fetchedOutlets;
      });
      _calculateDistances();
    }).catchError((error) {
      print('Error fetching outlets: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Outlet> filteredOutlets = outlets.where((outlet) {
      return outlet.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Outlet Laundry'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Outlet Laundry',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOutlets.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      filteredOutlets[index].imageUrl,
                      fit: BoxFit.cover,
                      ),
                    title: Text(filteredOutlets[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(filteredOutlets[index].location),
                        Text('${filteredOutlets[index].distance.toStringAsFixed(2)} km'),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context, filteredOutlets[index]);
                    },
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
