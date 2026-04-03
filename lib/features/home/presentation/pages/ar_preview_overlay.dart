import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';

class ARPreviewOverlay extends StatefulWidget {
  final ProductEntity product;
  const ARPreviewOverlay({super.key, required this.product});

  @override
  State<ARPreviewOverlay> createState() => _ARPreviewOverlayState();
}

class _ARPreviewOverlayState extends State<ARPreviewOverlay> {
  bool _isCalibrating = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isCalibrating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Camera Background (Dark/Blurry background or a placeholder image)
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.network(
                "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80", // Modern Room
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Close Button
          Positioned(
            top: 60, right: 24,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // AR UI Overlay
          if (_isCalibrating) _buildCalibrationUI() else _buildPlacedObject(),

          // AR Controls Bottom
          Positioned(
            bottom: 40, left: 24, right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _arAction(Icons.threed_rotation, "3D View"),
                _arAction(Icons.camera_alt_outlined, "Capture"),
                _arAction(Icons.share_outlined, "Social Share"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.view_in_ar, color: AppTheme.accentColor, size: 80)
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2.seconds)
              .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), curve: Curves.easeInOut),
          const SizedBox(height: 24),
          Text("Move your phone to calibrate...", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Identifying floor and lighting...", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPlacedObject() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Surface Grid Effect
          Container(
            width: 300, height: 300,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.accentColor.withOpacity(0.2), width: 1)),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 2.seconds).fadeOut(),

          // The Product itself hovering
          Image.network(widget.product.imageUrl, width: 250)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .slideY(begin: -0.05, end: 0.05, duration: 2.seconds, curve: Curves.easeInOut),
          
          Positioned(
            bottom: -20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.accentColor.withOpacity(0.3))),
              child: Text("TRUE-TO-LIFE SCALE SAVED", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
