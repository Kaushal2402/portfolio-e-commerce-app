import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

import 'order_success_page.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;
  const CheckoutPage({super.key, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPayment = 'Apple Pay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              _buildCheckoutForm(),
              _buildPaymentSelection(),
              _buildOrderSummary(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildConfirmAction(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: GlassmorphicContainer(
                width: 45, height: 45, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
                linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
                borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 20),
            Text("SECURE CHECKOUT", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutForm() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SHIPPING DETAILS", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 16),
              _buildTextField("Full Name", Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField("Shipping Address", Icons.location_on_outlined),
              const SizedBox(height: 16),
              _buildTextField("Phone Number", Icons.phone_outlined, isPhone: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isPhone = false}) {
    return GlassmorphicContainer(
      width: double.infinity, height: 60, borderRadius: 16, blur: 10, border: 0.5, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.03), Colors.white.withOpacity(0.01)]),
      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
      child: TextFormField(
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          hintText: label,
          hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPaymentSelection() {
    final methods = [
      {'name': 'Apple Pay', 'icon': Icons.apple},
      {'name': 'Credit Card', 'icon': Icons.credit_card},
      {'name': 'AI Wallet', 'icon': Icons.account_balance_wallet_outlined},
    ];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("PAYMENT METHOD", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 16),
            ...methods.map((m) => GestureDetector(
              onTap: () => setState(() => _selectedPayment = m['name'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedPayment == m['name'] ? AppTheme.accentColor.withOpacity(0.1) : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _selectedPayment == m['name'] ? AppTheme.accentColor.withOpacity(0.5) : Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(m['icon'] as IconData, color: _selectedPayment == m['name'] ? AppTheme.accentColor : Colors.white70),
                    const SizedBox(width: 16),
                    Text(m['name'] as String, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (_selectedPayment == m['name']) const Icon(Icons.check_circle, color: AppTheme.accentColor, size: 20),
                  ],
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: GlassmorphicContainer(
          width: double.infinity, height: 80, borderRadius: 20, blur: 10, border: 0.5, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.03), Colors.white.withOpacity(0.01)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("TOTAL AMOUNT", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text("₹ ${widget.totalAmount.toInt()}", style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text("AI Verified", style: GoogleFonts.outfit(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmAction(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: GlassmorphicContainer(
        width: double.infinity, height: 110 + MediaQuery.of(context).padding.bottom, borderRadius: 1, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.8), AppTheme.primaryColor]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.greenAccent, content: Text("Order Authenticated. Vaulting Transaction...", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderSuccessPage(amount: widget.totalAmount)));
              });
            },
            child: Container(
              height: 56, width: double.infinity,
              decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
              child: Center(
                child: Text("PLACE ORDER", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
