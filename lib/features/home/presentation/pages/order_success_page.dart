import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'order_tracking_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final double amount;
  const OrderSuccessPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final orderId = "#SC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final orderDate = "April 3, 2026";
    final estDelivery = "April 5, 2026";

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: AppTheme.accentColor.withOpacity(0.05), 
                boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)]
              )
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  _buildSuccessHeader(),
                  const SizedBox(height: 40),
                  _buildOrderDetailsCard(orderId, orderDate, estDelivery),
                  const SizedBox(height: 24),
                  _buildPaymentSummary(),
                  const Spacer(),
                  _buildActionButtons(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: AppTheme.accentColor.withOpacity(0.3))),
          child: const Icon(Icons.check_circle_rounded, color: AppTheme.accentColor, size: 60),
        ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut).shimmer(delay: 800.ms),
        const SizedBox(height: 24),
        Text("VAULT SECURED", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4)),
        const SizedBox(height: 8),
        Text("Order Placed Successfully", style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("Your items are being prepared for AI-optimized delivery.", textAlign: TextAlign.center, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14)),
      ],
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildOrderDetailsCard(String id, String date, String est) {
    return GlassmorphicContainer(
      width: double.infinity, height: 180, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _dataRow("Order Number", id, isBold: true),
            const Divider(color: Colors.white10, height: 32),
            _dataRow("Order Date", date),
            const SizedBox(height: 12),
            _dataRow("Est. Delivery", est, color: AppTheme.accentColor),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.1, end: 0, delay: 400.ms).fadeIn();
  }

  Widget _buildPaymentSummary() {
    return GlassmorphicContainer(
      width: double.infinity, height: 80, borderRadius: 20, blur: 10, border: 0.5, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.03), Colors.white.withOpacity(0.01)]),
      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("TOTAL AMOUNT PAID", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                Text("₹ ${amount.toInt()}", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Icon(Icons.apple, color: Colors.white, size: 24),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.1, end: 0, delay: 500.ms).fadeIn();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderTrackingPage())),
          child: Container(
            height: 56, width: double.infinity,
            decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Center(child: Text("TRACK PROGRESS", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2))),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Text("BACK TO DISCOVERY", style: GoogleFonts.outfit(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _dataRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
        Text(value, style: GoogleFonts.outfit(color: color ?? Colors.white, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
