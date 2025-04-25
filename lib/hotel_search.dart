import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

//dependencies:
//geolocator: ^10.1.0

//dependency_overrides:
//geolocator_android: ^4.1.7


void main() {
  runApp(const MaterialApp(
    home: NearbyHotelsPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NearbyHotelsPage extends StatefulWidget {
  const NearbyHotelsPage({super.key});

  @override
  State<NearbyHotelsPage> createState() => _NearbyHotelsPageState();
}

class _NearbyHotelsPageState extends State<NearbyHotelsPage> {
  String? locationMessage;
  bool isLoading = false;

  Future<void> _getCurrentLocationAndShowHotels() async {
    setState(() {
      isLoading = true;
      locationMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationMessage = 'Location services are disabled.';
          isLoading = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationMessage = 'Location permissions are denied';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = 'Location permissions are permanently denied.';
          isLoading = false;
        });
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      setState(() {
        locationMessage = 'Your location: ($lat, $lon)';
      });

      // Google Maps search URL
      final Uri url = Uri.parse('https://www.google.com/maps/search/hotels/@$lat,$lon,15z');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        setState(() {
          locationMessage = 'Could not launch Google Maps.';
        });
      }
    } catch (e) {
      setState(() {
        locationMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hotels")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isLoading ? null : _getCurrentLocationAndShowHotels,
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text("Find Nearby Hotels"),
              ),
              const SizedBox(height: 20),
              Text(
                locationMessage ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
