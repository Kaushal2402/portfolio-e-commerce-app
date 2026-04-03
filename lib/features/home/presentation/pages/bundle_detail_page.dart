import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class BundleDetailPage extends StatefulWidget {
  final Map<String, dynamic> bundle;
  const BundleDetailPage({super.key, required this.bundle});

  @override
  State<BundleDetailPage> createState() => _BundleDetailPageState();
}

class _BundleDetailPageState extends State<BundleDetailPage> {
  bool _isAdded = false;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    // Mocking products for the bundle based on category/price
    final List<ProductEntity> bundleProducts = [
      ProductEntity(
        id: 'b1', name: 'Premium Base Layer', category: 'Apparel', 
        price: widget.bundle['price'] * 0.4, imageUrl: widget.bundle['image'], matchScore: 0.98
      ),
      ProductEntity(
        id: 'b2', name: 'Accent Piece', category: 'Accessories', 
        price: widget.bundle['price'] * 0.3, imageUrl: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80", matchScore: 0.95
      ),
      ProductEntity(
        id: 'b3', name: 'Luxury Finisher', category: 'Audio', 
        price: widget.bundle['price'] * 0.3, imageUrl: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80", matchScore: 0.92
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              _buildBundleHeader(),
              _buildProductList(bundleProducts),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildBottomAction(context),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: SmartImage(imageUrl: widget.bundle['image'], fit: BoxFit.cover),
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

  Widget _buildBundleHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AI CURATED SET", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3)),
            const SizedBox(height: 8),
            Text(widget.bundle['title'], style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(widget.bundle['description'] ?? "A handpicked selection of premium items designed to complement your unique style persona.", style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductEntity> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SmartImage(imageUrl: product.imageUrl, width: 60, height: 60),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(product.category, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: GlassmorphicContainer(
        width: double.infinity, height: 110, borderRadius: 1, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.8), AppTheme.primaryColor]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isFavorited = !_isFavorited),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _isFavorited ? AppTheme.accentColor.withOpacity(0.5) : Colors.white10),
                    color: _isFavorited ? AppTheme.accentColor.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? AppTheme.accentColor : Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("BUNDLE PRICE", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text("₹ ${widget.bundle['price'].toInt()}", style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("SAVE ₹ ${(widget.bundle['price'] * 0.15).toInt()} (15%)", style: GoogleFonts.outfit(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _isAdded = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: AppTheme.accentColor, content: Text("Bundle added to Smart Cart", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: _isAdded ? Colors.greenAccent : AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: (_isAdded ? Colors.greenAccent : AppTheme.accentColor).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(_isAdded ? Icons.check_circle_outline : Icons.auto_awesome_outlined, color: Colors.black, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _isAdded ? "ADDED" : "ACQUIRE SET",
                        style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutCirc),
    );
  }
}
