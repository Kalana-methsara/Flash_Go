import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapScreen extends StatefulWidget {
  final String pickupName;
  final double pickupLat;
  final double pickupLng;
  final String dropName;
  final double dropLat;
  final double dropLng;

  const OrderMapScreen({
    super.key,
    required this.pickupName,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropName,
    required this.dropLat,
    required this.dropLng,
  });

  @override
  State<OrderMapScreen> createState() => _OrderMapScreenState();
}

class _OrderMapScreenState extends State<OrderMapScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final pickup = LatLng(widget.pickupLat, widget.pickupLng);
    final drop = LatLng(widget.dropLat, widget.dropLng);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        infoWindow: InfoWindow(title: 'Pickup', snippet: widget.pickupName),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: drop,
        infoWindow: InfoWindow(title: 'Drop', snippet: widget.dropName),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
      ),
    };

    // 💡 Direct straight line එකක් pickup -> drop අතර.
    // Actual road route එකක් ඕන නම් Google Directions API + flutter_polyline_points
    // package එක ඕන වෙනවා (billing enable කරන්න ඕන Google Cloud Console එකේ).
    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('route'),
        points: [pickup, drop],
        color: Colors.amber,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };

    final bounds = LatLngBounds(
      southwest: LatLng(
        pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude,
        pickup.longitude < drop.longitude
            ? pickup.longitude
            : drop.longitude,
      ),
      northeast: LatLng(
        pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude,
        pickup.longitude > drop.longitude
            ? pickup.longitude
            : drop.longitude,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map 🗺️',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: pickup, zoom: 15),
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              // 💡 map render වුනාට පස්සේ marker දෙකම screen එකේ fit වෙන විදිහට zoom කරනවා
              Future.delayed(const Duration(milliseconds: 300), () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngBounds(bounds, 80),
                );
              });
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Card(
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('Pickup: ${widget.pickupName}',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.navigation,
                            color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('Drop: ${widget.dropName}',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
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