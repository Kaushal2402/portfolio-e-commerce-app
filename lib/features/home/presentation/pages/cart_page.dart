import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showDetails = false;
  // Mocking cart items with quantities
  List<Map<String, dynamic>> _cartItems = [
    {
      'product': ProductEntity(id: 'c1', name: 'Midnight Audio Gen 2', category: 'Audio', price: 24999, imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80', matchScore: 0.98),
      'quantity': 1,
    },
    {
      'product': ProductEntity(id: 'c2', name: 'Minimalist Tech Shell', category: 'Apparel', price: 12499, imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&q=80', matchScore: 0.95),
      'quantity': 1,
    },
  ];

  // Pricing calculation
  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item['product'].price * item['quantity']));
  double get _tax => _subtotal * 0.18;
  double get _delivery => _subtotal > 0 ? 500 : 0;
  double get _discount => _subtotal * 0.10; // AI Loyalty Discount
  double get _total => _subtotal + _tax + _delivery - _discount;
  double get _cashback => _total * 0.05;
  double get _totalSaved => _discount + 200; // Loyalty + Promo

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cartItems[index]['quantity'] + delta;
      if (newQty > 0) {
        _cartItems[index]['quantity'] = newQty;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ProductEntity> upsellItems = [
      ProductEntity(id: 'u1', name: 'Carbon Fiber Case', category: 'Accessories', price: 4999, imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80', matchScore: 0.90),
      ProductEntity(id: 'u2', name: 'Smart Charging Dock', category: 'Tech', price: 8999, imageUrl: 'https://images.unsplash.com/photo-1585333127302-0444d1801535?auto=format&fit=crop&q=80', matchScore: 0.88),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              if (_cartItems.isEmpty)
                _buildEmptyState()
              else
                _buildCartList(),
              _buildUpsellSection(context, upsellItems),
              const SliverToBoxAdapter(child: SizedBox(height: 300)),
            ],
          ),
          _buildCheckoutAction(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 80),
            const SizedBox(height: 24),
            Text("Your Smart Cart is empty", style: GoogleFonts.outfit(color: Colors.white60, fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text("DISCOVER PRODUCTS", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: GlassmorphicContainer(
                width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
                linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
                borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
            Text("SMART CART", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _cartItems[index];
            final product = item['product'] as ProductEntity;
            final qty = item['quantity'] as int;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GlassmorphicContainer(
                width: double.infinity, height: 120, borderRadius: 20, blur: 10, border: 0.5, alignment: Alignment.center,
                linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.03), Colors.white.withOpacity(0.01)]),
                borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(12), child: SmartImage(imageUrl: product.imageUrl, width: 90, height: 90)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(product.category, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10)),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
                                _quantitySelector(index, qty),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: () => _removeItem(index), icon: const Icon(Icons.delete_outline, color: Colors.white30, size: 20)),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: -0.1, end: 0);
          },
          childCount: _cartItems.length,
        ),
      ),
    );
  }

  Widget _quantitySelector(int index, int qty) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(Icons.remove, () => _updateQuantity(index, -1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("$qty", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          _qtyBtn(Icons.add, () => _updateQuantity(index, 1)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }

  Widget _buildUpsellSection(BuildContext context, List<ProductEntity> upsells) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_outlined, color: AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Text("AI SUGGESTS: COMPLETE THE SET", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, itemCount: upsells.length,
                itemBuilder: (context, index) {
                  final item = upsells[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: item))),
                    child: Container(
                      width: 140, margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: SmartImage(imageUrl: item.imageUrl, width: double.infinity, height: double.infinity))),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1),
                                Text("₹ ${item.price.toInt()}", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms),
      ),
    );
  }

  Widget _buildCheckoutAction(BuildContext context) {
    if (_cartItems.isEmpty) return const SizedBox();
    
    return Positioned(
      bottom: 24, left: 24, right: 24,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showDetails ? 480 : 240,
        child: GlassmorphicContainer(
          width: double.infinity, height: double.infinity, borderRadius: 24, blur: 30, border: 1, alignment: Alignment.topCenter,
          linearGradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.95), AppTheme.primaryColor]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showDetails = !_showDetails),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_outlined, color: AppTheme.accentColor, size: 14),
                      const SizedBox(width: 8),
                      Text("AI PRICING INTELLIGENCE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      Icon(_showDetails ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: AppTheme.accentColor, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_showDetails) ...[
                  _priceRow("Subtotal", "₹ ${_subtotal.toInt()}"),
                  _priceRow("Tax (18%)", "₹ ${_tax.toInt()}"),
                  _priceRow("Premium Express Delivery", "₹ ${_delivery.toInt()}"),
                  _priceRow("AI Loyalty Discount", "-₹ ${_discount.toInt()}", isAccent: true),
                  _priceRow("Coupon: 'LUX2024'", "-₹ 200", isAccent: true),
                  const Divider(color: Colors.white10, height: 24),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL PAYABLE", style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.stars, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            Text("Cashback: ₹ ${_cashback.toInt()}", style: GoogleFonts.outfit(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("₹ ${_total.toInt()}", style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("You saved ₹ ${_totalSaved.toInt()}", style: GoogleFonts.outfit(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.greenAccent, content: Text("Optimizing Transaction Path...", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(totalAmount: _total)));
                  },
                  child: Container(
                    height: 56, width: double.infinity,
                    decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
                    child: Center(
                      child: Text("EXPRESS CHECKOUT", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ),
                  ),
                ).animate(target: _showDetails ? 1 : 0).shimmer(duration: 800.ms, color: Colors.white24).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: isAccent ? AppTheme.accentColor : Colors.white54, fontSize: 11, fontWeight: isAccent ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: GoogleFonts.outfit(color: isAccent ? AppTheme.accentColor : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
