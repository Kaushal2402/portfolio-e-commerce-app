import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'order_details_page.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {'id': 'SC-829102', 'date': 'Today, 12:45 PM', 'total': '₹ 44,500', 'status': 'IN TRANSIT', 'itemCount': 3},
      {'id': 'SC-771021', 'date': 'April 1, 2026', 'total': '₹ 12,200', 'status': 'DELIVERED', 'itemCount': 1},
      {'id': 'SC-652910', 'date': 'March 28, 2026', 'total': '₹ 8,900', 'status': 'DELIVERED', 'itemCount': 2},
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text("MY ORDERS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(context, order, index);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order, int index) {
    final bool isDelivered = order['status'] == 'DELIVERED';

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsPage())),
        child: GlassmorphicContainer(
          width: double.infinity, height: 180, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [isDelivered ? Colors.greenAccent.withOpacity(0.3) : AppTheme.accentColor.withOpacity(0.3), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order #${order['id']}", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(order['date'] as String, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    _statusBadge(order['status'] as String),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    _miniStack(order['itemCount'] as int),
                    const SizedBox(width: 12),
                    Text("${order['itemCount']} Items", style: GoogleFonts.outfit(color: Colors.white60, fontSize: 12)),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(order['total'] as String, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("VIEW DETAILS", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
  }

  Widget _miniStack(int count) {
    return SizedBox(
      width: 60, height: 32,
      child: Stack(
        children: List.generate(count > 3 ? 3 : count, (i) {
          return Positioned(
            left: (i * 12).toDouble(),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: Colors.white12, shape: BoxShape.circle, border: Border.all(color: AppTheme.primaryColor, width: 2)),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 14),
            ),
          );
        }),
      ),
    );
  }

  Widget _statusBadge(String text) {
    final bool isDelivered = text == 'DELIVERED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: isDelivered ? Colors.greenAccent.withOpacity(0.1) : AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.outfit(color: isDelivered ? Colors.greenAccent : AppTheme.accentColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }
}
