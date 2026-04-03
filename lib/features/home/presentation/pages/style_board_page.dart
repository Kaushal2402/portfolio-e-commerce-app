import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class StyleBoardPage extends StatelessWidget {
  final Map<String, dynamic> item;
  
  const StyleBoardPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Mocking tagged products for the social trend
    final taggedProduct = ProductEntity(
      id: 's1', name: 'Signature Series Item', category: 'Apparel', 
      price: 18999, imageUrl: item['image'], matchScore: 0.99
    );

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          SmartImage(imageUrl: item['image'], fit: BoxFit.cover),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.3), Colors.transparent, Colors.black.withOpacity(0.9)],
              ),
            ),
          ),
          
          // Content
          _buildContent(context, taggedProduct),
          
          // Back Button
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 50, left: 24,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: GlassmorphicContainer(
          width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductEntity product) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: CachedNetworkImageProvider(item['avatar'])),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['user'], style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
                    Text("TRENDSETTER • 4.2k Posts", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 20),
            Text(
              item['comment'],
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
            const SizedBox(height: 32),
            
            // Tagged Product Card
            Text("SHOP THIS LOOK", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
              child: GlassmorphicContainer(
                width: double.infinity, height: 90, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
                linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
                borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(12), child: SmartImage(imageUrl: product.imageUrl, width: 60, height: 60)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
                            Text("Featured in Trend", style: GoogleFonts.outfit(color: Colors.white60, fontSize: 10)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
