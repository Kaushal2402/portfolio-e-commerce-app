import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'order_tracking_page.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int _rating = 0;
  double _tipAmount = 0;
  bool _isCancelled = false;
  bool _showReviewInput = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              _buildOrderSummary(),
              _buildItemsList(),
              _buildRatingSection(),
              _buildTippingSection(),
              _buildCancellationLink(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          if (_isCancelled) _buildCancellationOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.8), elevation: 0, leadingWidth: 80, pinned: true,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: GlassmorphicContainer(
            width: 40, height: 40, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
            linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
            borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
        ),
      ),
      title: Text("ORDER DETAILS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
      centerTitle: true,
    );
  }

  Widget _buildOrderSummary() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassmorphicContainer(
          width: double.infinity, height: 180, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)]),
          borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.2), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order #SC-829102", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("April 3, 2026 • 12:45 PM", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    _statusBadge("IN TRANSIT"),
                  ],
                ),
                const Divider(color: Colors.white10, height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _summaryStat("Items", "3"),
                    _summaryStat("Total Payable", "₹ 44,500"),
                    _actionButton("TRACK", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderTrackingPage()))),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn().slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildItemsList() {
    final items = [
      {'title': 'Urban Tactical Techwear', 'price': '₹ 12,000', 'desc': 'Size: L • Black'},
      {'title': 'Midnight Alpha Boots', 'price': '₹ 24,500', 'desc': 'Size: 42 • Matte'},
      {'title': 'Stealth Cargo Pack', 'price': '₹ 8,000', 'desc': 'Universal • Grey'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text("ORDERED ITEMS", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)));
            final item = items[index - 1];
            return _itemTile(item['title']!, item['price']!, item['desc']!);
          },
          childCount: items.length + 1,
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("RATE YOUR EXPERIENCE", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            GlassmorphicContainer(
              width: double.infinity, height: _showReviewInput ? 240 : 120, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
              linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
              borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final bool active = index < _rating;
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(active ? Icons.star_rounded : Icons.star_outline_rounded, color: active ? Colors.amber : Colors.white12, size: 36),
                        ),
                      ).animate(target: active ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms);
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(_rating == 0 ? "How was the service?" : ["Needs Work", "Okay", "Good", "Great", "Excellent!"][_rating - 1], style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                  if (_rating > 0 && !_showReviewInput)
                    TextButton(onPressed: () => setState(() => _showReviewInput = true), child: Text("Write a Review", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.bold))),
                  if (_showReviewInput)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        height: 80, padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                        child: TextField(style: GoogleFonts.outfit(color: Colors.white, fontSize: 13), decoration: const InputDecoration(hintText: "Add your feedback...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white24))),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTippingSection() {
    final amounts = [10.0, 20.0, 50.0];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SUPPORT THE DELIVERER", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...amounts.map((a) {
                  final isSelected = _tipAmount == a;
                  return GestureDetector(
                    onTap: () => setState(() => _tipAmount = a),
                    child: GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width * 0.22, height: 56, borderRadius: 16, blur: 10, border: 1, alignment: Alignment.center,
                      linearGradient: LinearGradient(colors: [isSelected ? AppTheme.accentColor.withOpacity(0.2) : Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
                      borderGradient: LinearGradient(colors: [isSelected ? AppTheme.accentColor : Colors.white.withOpacity(0.1), Colors.transparent]),
                      child: Text("₹ ${a.toInt()}", style: GoogleFonts.outfit(color: isSelected ? AppTheme.accentColor : Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: GlassmorphicContainer(
                          width: 300, height: 180, borderRadius: 24, blur: 30, border: 1, alignment: Alignment.center,
                          linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.9)]),
                          borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("CUSTOM TIP (₹)", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 24, fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(border: InputBorder.none, hintText: "00.00", hintStyle: TextStyle(color: Colors.white10)),
                                  onSubmitted: (val) {
                                    setState(() => _tipAmount = double.tryParse(val) ?? 0);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: GlassmorphicContainer(
                    width: MediaQuery.of(context).size.width * 0.18, height: 56, borderRadius: 16, blur: 10, border: 1, alignment: Alignment.center,
                    linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
                    borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                    child: const Icon(Icons.add, color: Colors.white60),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancellationLink() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Center(
          child: TextButton(
            onPressed: () => setState(() => _isCancelled = true),
            child: Text("CANCEL TRANSACTION", style: GoogleFonts.outfit(color: Colors.redAccent.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildCancellationOverlay() {
    return GlassmorphicContainer(
      width: double.infinity, height: double.infinity, borderRadius: 0, blur: 40, border: 0, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.85), Colors.black.withOpacity(0.95)]),
      borderGradient: const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 72).animate().shake(hz: 4),
            const SizedBox(height: 32),
            Text("Confirm Cancellation?", style: GoogleFonts.outfit(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("This is an AI-optimized limited drop. Cancelling may result in permanent stock loss for your style profile.", textAlign: TextAlign.center, style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14, height: 1.5)),
            const SizedBox(height: 48),
            _actionBtn("WITHDRAW ORDER", Colors.redAccent, () => Navigator.pop(context)),
            const SizedBox(height: 16),
            _actionBtn("BACK TO SAFETY", Colors.white12, () => setState(() => _isCancelled = false)),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56, width: double.infinity,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2))),
      ),
    );
  }

  Widget _itemTile(String title, String price, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Text(price, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _summaryStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)),
    );
  }
}
