import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/product_entity.dart';
import 'express_checkout_overlay.dart';
import 'ar_preview_overlay.dart';
import 'product_360_viewer.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isAdded = false;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(context),
              _buildProductInfo(),
              _buildAIReasoning(),
              _buildSpecifications(),
              const SliverToBoxAdapter(child: SizedBox(height: 200)),
            ],
          ),
          _buildBottomAction(context),
          _buildBackButton(context),
          _buildAR360Controls(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'product-${widget.product.id}',
              child: SmartImage(imageUrl: widget.product.imageUrl),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.primaryColor,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 50,
      left: 24,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: GlassmorphicContainer(
          width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
      ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
    );
  }

  Widget _buildProductInfo() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.category.toUpperCase(),
                  style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                _matchBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.name,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.1),
            ),
            const SizedBox(height: 16),
            Text(
              "₹ ${widget.product.price.toInt()}",
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _matchBadge() {
    return GlassmorphicContainer(
      width: 90, height: 32, borderRadius: 16, blur: 5, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.2), AppTheme.accentColor.withOpacity(0.05)]),
      borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 12),
          const SizedBox(width: 4),
          Text("${(widget.product.matchScore * 100).toInt()}% AI", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAIReasoning() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   const Icon(Icons.psychology_outlined, color: AppTheme.accentColor, size: 20),
                   const SizedBox(width: 12),
                   Text("WHY IT MATCHES YOU", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Based on your recent interest in ${widget.product.category} and your Minimalist Persona, this item scores highly in build quality and design alignment.",
                style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14, height: 1.6),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
      ),
    );
  }

  Widget _buildSpecifications() {
    final specs = ["Premium Material", "Eco-Friendly", "AI-Authenticated", "Global Warranty"];
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(specs[index], style: GoogleFonts.outfit(color: Colors.white54, fontSize: 11))),
              ],
            ),
          ),
          childCount: specs.length,
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: GlassmorphicContainer(
        width: double.infinity, height: 160, borderRadius: 1, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.8), AppTheme.primaryColor]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExpressButton(context),
              const SizedBox(height: 12),
              Row(
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isAdded = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.accentColor,
                            content: Text("${widget.product.name} added to Smart Cart", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 56,
                        decoration: BoxDecoration(
                          color: _isAdded ? Colors.greenAccent : AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(color: (_isAdded ? Colors.greenAccent : AppTheme.accentColor).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_isAdded ? Icons.check_circle_outline : Icons.shopping_bag_outlined, color: Colors.black, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                _isAdded ? "ADDED" : "ACQUIRE NOW",
                                style: GoogleFonts.outfit(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
                              ),
                            ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutCirc),
    );
  }

Widget _buildExpressButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (context) => ExpressCheckoutOverlay(product: widget.product),
      );
    },
    child: Container(
      height: 50, width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.9)]),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bolt, color: Colors.black, size: 20),
          const SizedBox(width: 8),
          Text("EXPRESS 1-TAP CHECKOUT", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
        ],
      ),
    ),
  );
  }

  Widget _buildAR360Controls(BuildContext context) {
    return Positioned(
      top: 50,
      right: 24,
      child: Column(
        children: [
          _overlayButton(
            Icons.view_in_ar, 
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => ARPreviewOverlay(product: widget.product))),
          ),
          const SizedBox(height: 12),
          _overlayButton(
            Icons.threed_rotation, 
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => Product360Viewer(product: widget.product))),
          ),
        ],
      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.2),
    );
  }

  Widget _overlayButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
