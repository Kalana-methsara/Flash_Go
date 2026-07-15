import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../app_strings.dart';

class PickedLocation {
  final String name;
  final double latitude;
  final double longitude;

  PickedLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationPickerScreen extends StatefulWidget {
  final String? title;
  const LocationPickerScreen({super.key, this.title});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  LatLng _pickedLatLng = const LatLng(7.2906, 80.6337);

  final TextEditingController _nameController = TextEditingController();
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _loadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _pickedLatLng = LatLng(position.latitude, position.longitude);
        _loadingLocation = false;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_pickedLatLng));
    } catch (e) {
      debugPrint('⚠️ Location fetch failed: $e');
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _confirmLocation() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('enter_location_name_error'))),
      );
      return;
    }

    Navigator.pop(
      context,
      PickedLocation(
        name: _nameController.text.trim(),
        latitude: _pickedLatLng.latitude,
        longitude: _pickedLatLng.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? context.tr('pick_location_title'))),
      body: _loadingLocation
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _pickedLatLng, zoom: 17),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: (position) => _pickedLatLng = position.target,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.location_pin, size: 48, color: Colors.redAccent),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: context.tr('location_name_label'),
                              hintText: context.tr('location_name_hint'),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _confirmLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(context.tr('confirm_location'),
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}