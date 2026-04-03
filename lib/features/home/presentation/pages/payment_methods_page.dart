import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(),
            const SizedBox(height: 32),
            Text("SAVED CARDS", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 16),
            _buildCardTile(context, "Apple Pay", "**** 4242", Icons.apple, isDefault: true),
            _buildCardTile(context, "Visa Platinum", "**** 8890", Icons.credit_card_outlined),
            _buildCardTile(context, "Mastercard Elite", "**** 1122", Icons.credit_card_outlined),
            const SizedBox(height: 8),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Text("PAYMENT METHODS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildWalletCard() {
    return GlassmorphicContainer(
      width: double.infinity, height: 180, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.accentColor.withOpacity(0.2), AppTheme.primaryColor.withOpacity(0.4)]),
      borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AI SMART WALLET", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 16),
              ],
            ),
            const Spacer(),
            Text("₹ 12,450.00", style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Available for specialized commerce", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildCardTile(BuildContext context, String label, String number, IconData icon, {bool isDefault = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassmorphicContainer(
        width: double.infinity, height: 80, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [isDefault ? AppTheme.accentColor.withOpacity(0.5) : Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(number, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              if (isDefault) _tag("PRIMARY"),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white24, size: 20),
                onPressed: () {
                  showModalBottomSheet(
                    context: context, backgroundColor: Colors.transparent,
                    builder: (context) => GlassmorphicContainer(
                      width: double.infinity, height: 200, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
                      linearGradient: LinearGradient(colors: [AppTheme.primaryColor, Colors.black]),
                      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(leading: const Icon(Icons.edit_outlined, color: Colors.white), title: Text("Edit Payment Method", style: GoogleFonts.outfit(color: Colors.white)), onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AI-Secured: Entering edit mode...")));
                          }),
                          ListTile(leading: const Icon(Icons.delete_outline, color: Colors.redAccent), title: Text("Remove Method", style: GoogleFonts.outfit(color: Colors.redAccent)), onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Security Protocol: Payment method removed.")));
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.secondaryColor,
            title: Text("ADD NEW CARD", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Text("Redirecting to AI-Secured Payment Gateway for biometric card verification...", style: GoogleFonts.outfit(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL", style: GoogleFonts.outfit(color: Colors.white38))),
              TextButton(onPressed: () => Navigator.pop(context), child: Text("PROCEED", style: GoogleFonts.outfit(color: AppTheme.accentColor))),
            ],
          ),
        );
      },
      child: Container(
        height: 60, width: double.infinity,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1), style: BorderStyle.solid)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              Text("ADD PAYMENT METHOD", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }
}
