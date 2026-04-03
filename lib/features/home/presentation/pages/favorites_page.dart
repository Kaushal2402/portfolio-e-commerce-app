import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductEntity> favorites = [
      const ProductEntity(id: '1', name: 'Alpha Tactical Jacket', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&q=80', price: 18500, category: 'Outerwear', matchScore: 0.98),
      const ProductEntity(id: '2', name: 'Stealth Cargo Pants', imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&q=80', price: 9200, category: 'Bottoms', matchScore: 0.95),
      const ProductEntity(id: '3', name: 'Cyberpunk Tech Boots', imageUrl: 'https://images.unsplash.com/photo-1605812860427-4024433a70fd?auto=format&fit=crop&q=80', price: 24000, category: 'Footwear', matchScore: 0.92),
      const ProductEntity(id: '4', name: 'Neon Guardian Mask', imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80', price: 4500, category: 'Accessories', matchScore: 0.88),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text("MY FAVORITES", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.7),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return _buildFavoriteCard(context, favorites[index], index);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, ProductEntity product, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
      child: GlassmorphicContainer(
        width: double.infinity, height: double.infinity, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                   ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: SmartImage(imageUrl: product.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, color: AppTheme.accentColor, size: 18),
                    ),
                  ),
                  Positioned(
                    bottom: 12, left: 12,
                    child: _matchBadge(product.matchScore),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _matchBadge(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: Colors.black, size: 10),
          const SizedBox(width: 4),
          Text("${(score * 100).toInt()}%", style: GoogleFonts.outfit(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
