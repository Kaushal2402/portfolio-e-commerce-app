import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {'title': 'New Style Drop!', 'desc': 'AI curator found an Alpha Boots match for your profile.', 'time': '2m ago', 'type': 'ALERT'},
      {'title': 'Price Drop Alert', 'desc': 'Stealth Cargo Pack is now 15% off for next 2 hours.', 'time': '1h ago', 'type': 'OFFER'},
      {'title': 'Order Dispatched', 'desc': 'Your order #SC-829102 is on its way to your vault.', 'time': '4h ago', 'type': 'ORDER'},
      {'title': 'Style Quiz Update', 'desc': 'Complete your seasonal quiz to unlock new AI drops.', 'time': 'Yesterday', 'type': 'SYSTEM'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text("SMART NOTIFICATIONS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notify = notifications[index];
          return _buildNotificationTile(notify, index);
        },
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notify, int index) {
    IconData icon;
    Color color;

    switch (notify['type']) {
      case 'ALERT': icon = Icons.auto_awesome; color = AppTheme.accentColor; break;
      case 'OFFER': icon = Icons.local_offer_outlined; color = Colors.greenAccent; break;
      case 'ORDER': icon = Icons.local_shipping_outlined; color = Colors.blueAccent; break;
      default: icon = Icons.info_outline; color = Colors.white38;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GlassmorphicContainer(
        width: double.infinity, height: 100, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [color.withOpacity(0.3), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(notify['title'] as String, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(notify['time'] as String, style: GoogleFonts.outfit(color: Colors.white24, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notify['desc'] as String, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
  }
}
