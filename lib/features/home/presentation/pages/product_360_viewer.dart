import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';

class Product360Viewer extends StatefulWidget {
  final ProductEntity product;
  const Product360Viewer({super.key, required this.product});

  @override
  State<Product360Viewer> createState() => _Product360ViewerState();
}

class _Product360ViewerState extends State<Product360Viewer> {
  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("360° HYPER-VIEW", style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("DRAG TO ROTATE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3)),
          const SizedBox(height: 60),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _rotation += details.delta.dx / 100;
              });
            },
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Base Shadow
                  Container(
                    width: 200, height: 20,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(100), boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)]),
                  ),
                  
                  // Product with 3D Transform
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(_rotation),
                    child: Image.network(widget.product.imageUrl, width: 300),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          _buildInfoPill(),
          const Spacer(),
          _buildActionButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionBtn(Icons.threed_rotation, "3D View", () {}),
          _actionBtn(Icons.camera_alt_outlined, "Capture", () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: AppTheme.accentColor, content: Text("Product Scan Captured to Style Vault", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
            );
          }),
          _actionBtn(Icons.share_outlined, "Social Share", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Preparing high-fidelity asset for sharing...")),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.1))),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.1))),
      child: Column(
        children: [
          Text(widget.product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("High-Fidelity 3D Capture • AI Enhanced", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0);
  }
}
