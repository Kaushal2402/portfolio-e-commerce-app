import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'order_tracking_page.dart';
import 'order_details_page.dart';
import 'order_list_page.dart';
import 'edit_profile_page.dart';
import 'address_page.dart';
import 'payment_methods_page.dart';
import 'ai_style_profile_page.dart';
import 'wallet_history_page.dart';
import 'vault_settings_page.dart';
import 'notifications_page.dart';
import 'favorites_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -100, left: -100, child: _glow(400, AppTheme.accentColor.withOpacity(0.05))),
          Positioned(bottom: 100, right: -100, child: _glow(300, Colors.purple.withOpacity(0.03))),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(context),
                SliverToBoxAdapter(child: const SizedBox(height: 32)),
                _buildMenuSection(context),
                SliverToBoxAdapter(child: const SizedBox(height: 100)), // Bottom nav padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size, height: size, 
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: color.withOpacity(0.01), 
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: size / 4)]
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 2)),
                  child: const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80')),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.black, size: 16),
                  ),
                ),
              ],
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text("Alex Harrison", style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 14),
                const SizedBox(width: 8),
                Text("AI STYLE ENTHUSIAST • LVL 12", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.shopping_bag_outlined, 'title': 'My Orders', 'subtitle': 'Track & Manage Purchases', 'page': const OrderListPage()},
      {'icon': Icons.auto_fix_high_outlined, 'title': 'AI Style Profile', 'subtitle': 'Personalized Fit & Trends', 'page': const AIStyleProfilePage()},
      {'icon': Icons.account_balance_wallet_outlined, 'title': 'AI Wallet', 'subtitle': '₹ 12,450.00 • Cashback inside', 'page': const WalletHistoryPage()},
      {'icon': Icons.location_on_outlined, 'title': 'Shipping Addresses', 'subtitle': 'Home, Work & 2 Others', 'page': const AddressPage()},
      {'icon': Icons.credit_card_outlined, 'title': 'Payment Methods', 'subtitle': 'Apple Pay • **** 4242', 'page': const PaymentMethodsPage()},
      {'icon': Icons.favorite_border_outlined, 'title': 'My Favorites', 'subtitle': '4 Saved Product Drops', 'page': const FavoritesPage()},
      {'icon': Icons.notifications_none_outlined, 'title': 'Smart Notifications', 'subtitle': 'Trends & Drop Alerts', 'page': const NotificationsPage()},
      {'icon': Icons.settings_outlined, 'title': 'Vault Settings', 'subtitle': 'Security & Data Privacy', 'page': const VaultSettingsPage()},
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = menuItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  if (item['page'] != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => item['page']));
                  }
                },
                child: GlassmorphicContainer(
                  width: double.infinity, height: 80, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
                  linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
                  borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                          child: Icon(item['icon'], color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item['title'], style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(item['subtitle'], style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white24),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().slideX(begin: 0.1, end: 0, delay: (100 * index).ms).fadeIn();
          },
          childCount: menuItems.length,
        ),
      ),
    );
  }
}
