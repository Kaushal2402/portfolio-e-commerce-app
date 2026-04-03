import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  GoogleMapController? _mapController;
  final LatLng _center = const LatLng(19.0760, 72.8777); // Default Mumbai
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: const LatLng(19.0800, 72.8800),
        infoWindow: const InfoWindow(title: 'Alex (Delivery Partner)'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
  }

  Future<void> _onCurrentLocationPressed() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15),
      ),
    );
  }

  Future<void> _onCallDriverPressed() async {
    final Uri url = Uri.parse('tel:+911234567890');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch dialer')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          _buildGoogleMap(),
          _buildTrackingHeader(context),
          _buildMapActions(),
          _buildTrackingOverlay(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (controller) => _mapController = controller,
      initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal, // Style is applied via _mapStyle
      style: _mapStyle,
    );
  }

  Widget _buildMapActions() {
    return Positioned(
      right: 24, top: 120,
      child: Column(
        children: [
          GestureDetector(
            onTap: _onCurrentLocationPressed,
            child: _glassActionIcon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _mapController?.animateCamera(CameraUpdate.zoomIn()),
            child: _glassActionIcon(Icons.add),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _mapController?.animateCamera(CameraUpdate.zoomOut()),
            child: _glassActionIcon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Widget _glassActionIcon(IconData icon) {
    return GlassmorphicContainer(
      width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTrackingHeader(BuildContext context) {
    return Positioned(
      top: 60, left: 24, right: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassmorphicContainer(
              width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
              linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
              borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          Text("LIVE TRACKING", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
          _glassActionIcon(Icons.auto_awesome),
        ],
      ),
    );
  }

  Widget _buildTrackingOverlay() {
    final List<Map<String, dynamic>> statuses = [
      {'title': 'Order Confirmed', 'time': '10:30 AM', 'done': true},
      {'title': 'AI Verification Complete', 'time': '10:45 AM', 'done': true},
      {'title': 'Packed & Quality Checked', 'time': '11:00 AM', 'done': true},
      {'title': 'Out for Delivery (EV Drone)', 'time': 'Now', 'done': false, 'active': true},
      {'title': 'Arriving at Destination', 'time': 'Est. 12:30 PM', 'done': false},
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.35, minChildSize: 0.35, maxChildSize: 0.85,
      builder: (context, scrollController) {
        return GlassmorphicContainer(
          width: double.infinity, height: double.infinity, borderRadius: 32, blur: 30, border: 1, alignment: Alignment.topCenter,
          linearGradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.85), AppTheme.primaryColor.withOpacity(0.95)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delivery Partner: Alex", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("Vanguard Logistics • EV Drone", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _onCallDriverPressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.accentColor.withOpacity(0.3))),
                      child: const Icon(Icons.phone_outlined, color: AppTheme.accentColor, size: 20),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, height: 32),
              Text("TRANSIT INTELLIGENCE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 24),
              ...statuses.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                return _buildStatusItem(s['title'], s['time'], s['done'], s['active'] ?? false, i == statuses.length - 1);
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(String title, String time, bool isDone, bool isActive, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: isDone ? AppTheme.accentColor : (isActive ? AppTheme.accentColor : Colors.white10),
                  shape: BoxShape.circle,
                  boxShadow: isActive ? [BoxShadow(color: AppTheme.accentColor.withOpacity(0.5), blurRadius: 10)] : [],
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 1, color: isDone ? AppTheme.accentColor : Colors.white10)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(color: isDone || isActive ? Colors.white : Colors.white38, fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
                  Text(time, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#212121"}]
  },
  {
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#212121"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#000000"}]
  }
]
''';
}
