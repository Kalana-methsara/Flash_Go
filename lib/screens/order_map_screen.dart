import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String kGoogleDirectionsApiKey = 'AIzaSyDRkBb1x-jmUMx0pkevQwg9MwYwDpN_ABU'; 

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

  late final LatLng _pickup;
  late final LatLng _drop;

  List<LatLng> _routePoints = [];
  String? _distanceText;
  String? _durationText;
  bool _loadingRoute = true;
  bool _routeError = false;

  @override
  void initState() {
    super.initState();
    _pickup = LatLng(widget.pickupLat, widget.pickupLng);
    _drop = LatLng(widget.dropLat, widget.dropLng);
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    try {
      final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
        'origin': '${_pickup.latitude},${_pickup.longitude}',
        'destination': '${_drop.latitude},${_drop.longitude}',
        'mode': 'driving',
        'key': kGoogleDirectionsApiKey,
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && (data['routes'] as List).isNotEmpty) {
        final route = data['routes'][0];
        final leg = route['legs'][0];
        final encoded = route['overview_polyline']['points'] as String;

        setState(() {
          _routePoints = _decodePolyline(encoded);
          _distanceText = leg['distance']['text'];
          _durationText = leg['duration']['text'];
          _loadingRoute = false;
        });
      } else {
        debugPrint('⚠️ Directions API status: ${data['status']} — ${data['error_message'] ?? ''}');
        _fallbackToStraightLine();
      }
    } catch (e) {
      debugPrint('⚠️ Directions fetch failed: $e');
      _fallbackToStraightLine();
    }

    
    Future.delayed(const Duration(milliseconds: 300), _fitBounds);
  }

  void _fallbackToStraightLine() {
    if (!mounted) return;
    setState(() {
      _routePoints = [_pickup, _drop];
      _routeError = true;
      _loadingRoute = false;
    });
  }

  
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _fitBounds() {
    if (_mapController == null) return;

    final allPoints = _routePoints.isNotEmpty ? _routePoints : [_pickup, _drop];

    double minLat = allPoints.first.latitude, maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude, maxLng = allPoints.first.longitude;

    for (final p in allPoints) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        90,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickup,
        infoWindow: InfoWindow(title: 'Pickup', snippet: widget.pickupName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: _drop,
        infoWindow: InfoWindow(title: 'Drop', snippet: widget.dropName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints.isNotEmpty ? _routePoints : [_pickup, _drop],
        color: Colors.amber,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _pickup, zoom: 15),
            markers: markers,
            polylines: polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 180, top: 100),
            onMapCreated: (controller) {
              _mapController = controller;
              _fitBounds();
            },
          ),

          
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: _RoundIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: _RoundIconButton(
              icon: Icons.my_location_rounded,
              onTap: _fitBounds,
            ),
          ),

          
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _RouteInfoSheet(
              pickupName: widget.pickupName,
              dropName: widget.dropName,
              distanceText: _distanceText,
              durationText: _durationText,
              loading: _loadingRoute,
              usingFallback: _routeError,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}

class _RouteInfoSheet extends StatelessWidget {
  final String pickupName;
  final String dropName;
  final String? distanceText;
  final String? durationText;
  final bool loading;
  final bool usingFallback;

  const _RouteInfoSheet({
    required this.pickupName,
    required this.dropName,
    required this.distanceText,
    required this.durationText,
    required this.loading,
    required this.usingFallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 18, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          
          if (loading)
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                ),
                SizedBox(width: 10),
                Text('Route calculate කරමින්...',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            )
          else
            Row(
              children: [
                _InfoChip(
                  icon: Icons.route_rounded,
                  label: distanceText ?? '—',
                ),
                const SizedBox(width: 10),
                _InfoChip(
                  icon: Icons.timer_outlined,
                  label: durationText ?? '—',
                ),
                if (usingFallback) ...[
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Approx. straight-line',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ],
            ),

          const SizedBox(height: 18),

          _LocationRow(
            icon: Icons.circle,
            iconColor: Colors.redAccent,
            iconSize: 10,
            label: 'Pickup',
            value: pickupName,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              width: 2,
              height: 22,
              color: Colors.grey[300],
            ),
          ),
          _LocationRow(
            icon: Icons.location_on,
            iconColor: Colors.green,
            iconSize: 18,
            label: 'Drop',
            value: dropName,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String label;
  final String value;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}