import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'add_address_page.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {'label': 'Home', 'address': '221B Baker Street, London, NW1 6XE', 'isDefault': true},
      {'label': 'Work', 'address': '1 Infinite Loop, Cupertino, CA 95014', 'isDefault': false},
      {'label': 'Gym', 'address': 'Muscle Beach, Venice, CA 90291', 'isDefault': false},
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar(context),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: addresses.length + 1,
        itemBuilder: (context, index) {
          if (index == addresses.length) return _buildAddButton(context);
          final addr = addresses[index];
          return _buildAddressCard(context, addr['label'] as String, addr['address'] as String, addr['isDefault'] as bool);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Text("SHIPPING ADDRESSES", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildAddressCard(BuildContext context, String label, String address, bool isDefault) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAddressPage())),
        child: GlassmorphicContainer(
          width: double.infinity, height: 100, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [isDefault ? AppTheme.accentColor.withOpacity(0.1) : Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [isDefault ? AppTheme.accentColor : Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(label == 'Home' ? Icons.home_outlined : Icons.work_outline, color: isDefault ? AppTheme.accentColor : Colors.white38),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(label, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            _tag("DEFAULT"),
                          ],
                        ],
                      ),
                      Text(address, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 20), 
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.redAccent, content: Text("Address removed from your profile", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAddressPage())),
      child: Container(
        height: 60, width: double.infinity,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.1), style: BorderStyle.solid)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              Text("ADD NEW ADDRESS", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
