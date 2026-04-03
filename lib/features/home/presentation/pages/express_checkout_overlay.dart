import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';
import 'order_success_page.dart';

class ExpressCheckoutOverlay extends StatefulWidget {
  final ProductEntity product;
  const ExpressCheckoutOverlay({super.key, required this.product});

  @override
  State<ExpressCheckoutOverlay> createState() => _ExpressCheckoutOverlayState();
}

class _ExpressCheckoutOverlayState extends State<ExpressCheckoutOverlay> {
  bool _isAuthenticating = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _startAuthSimulation();
  }

  void _startAuthSimulation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isAuthenticating = false);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _isSuccess = true);
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSuccessPage(amount: widget.product.price)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity, height: 400, borderRadius: 32, blur: 20, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.9), Colors.black]),
      borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text("EXPRESS 1-TAP CHECKOUT", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3)),
            const SizedBox(height: 32),
            if (_isAuthenticating) _buildAuthScan(),
            if (!_isAuthenticating && !_isSuccess) _buildOrderSummary(),
            if (_isSuccess) _buildSuccessCheck(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthScan() {
    return Column(
      children: [
        const Icon(Icons.fingerprint, color: AppTheme.accentColor, size: 60)
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1.seconds)
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), curve: Curves.easeInOut),
        const SizedBox(height: 24),
        Text("Authenticating with FaceID...", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(widget.product.imageUrl), fit: BoxFit.cover))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("₹ ${widget.product.price.toInt()}", style: GoogleFonts.outfit(color: AppTheme.accentColor)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _detailRow(Icons.location_on_outlined, "Shipping to Home Vault"),
        _detailRow(Icons.credit_card, "Paying with Apple Pay"),
        const SizedBox(height: 24),
        const LinearProgressIndicator(backgroundColor: Colors.white10, color: AppTheme.accentColor),
      ],
    ).animate().fadeIn();
  }

  Widget _buildSuccessCheck() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.black, size: 40),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 24),
        Text("PURCHASE SECURED!", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text("AI-Verified Transaction #SC-7712", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
