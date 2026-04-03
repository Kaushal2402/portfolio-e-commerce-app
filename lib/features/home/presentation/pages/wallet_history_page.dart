import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class WalletHistoryPage extends StatelessWidget {
  const WalletHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {'title': 'Cashback Credit', 'amount': '+ ₹ 450.00', 'date': 'Today, 02:30 PM', 'type': 'CREDIT'},
      {'title': 'Order #SC-829102', 'amount': '- ₹ 12,000.00', 'date': 'Yesterday, 12:45 PM', 'type': 'DEBIT'},
      {'title': 'Referral Bonus', 'amount': '+ ₹ 1,000.00', 'date': 'April 1, 2026', 'type': 'CREDIT'},
      {'title': 'Style Quiz Reward', 'amount': '+ ₹ 250.00', 'date': 'March 30, 2026', 'type': 'CREDIT'},
      {'title': 'Vault Protection Fee', 'amount': '- ₹ 99.00', 'date': 'March 28, 2026', 'type': 'EXPIRED'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildBalanceCard(),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(24, 32, 24, 16), child: Text("TRANSACTION HISTORY", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildTransactionTile(transactions[index], index),
              childCount: transactions.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Text("AI WALLET", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildBalanceCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassmorphicContainer(
          width: double.infinity, height: 160, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.accentColor.withOpacity(0.2), Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("AVAILABLE BALANCE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text("₹ 12,450.00", style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _tag("ACTIVE SECURE VAULT"),
            ],
          ),
        ),
      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> tx, int index) {
    final bool isCredit = tx['type'] == 'CREDIT';
    final bool isExpired = tx['type'] == 'EXPIRED';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: GlassmorphicContainer(
        width: double.infinity, height: 80, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [isCredit ? Colors.greenAccent.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                child: Icon(isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline, color: isCredit ? Colors.greenAccent : (isExpired ? Colors.white24 : Colors.redAccent), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tx['title'] as String, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(tx['date'] as String, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Text(tx['amount'] as String, style: GoogleFonts.outfit(color: isCredit ? Colors.greenAccent : (isExpired ? Colors.white24 : Colors.white), fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }
}
