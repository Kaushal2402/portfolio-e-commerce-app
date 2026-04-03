import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class VaultSettingsPage extends StatefulWidget {
  const VaultSettingsPage({super.key});

  @override
  State<VaultSettingsPage> createState() => _VaultSettingsPageState();
}

class _VaultSettingsPageState extends State<VaultSettingsPage> {
  bool _biometricLogin = true;
  bool _secureCheckout = true;
  bool _anonymousTracking = false;
  bool _aiPredictiveStyling = true;

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
            _buildSectionHeader("SECURITY & ACCESS"),
            const SizedBox(height: 16),
            _buildSettingTile("Biometric Authentication", "Use FaceID/Fingerprint for login", _biometricLogin, (v) => setState(() => _biometricLogin = v), Icons.fingerprint),
            _buildSettingTile("Secure Express Checkout", "AI-verified instant payments", _secureCheckout, (v) => setState(() => _secureCheckout = v), Icons.bolt_outlined),
            const SizedBox(height: 32),
            _buildSectionHeader("PRIVACY & DATA"),
            const SizedBox(height: 16),
            _buildSettingTile("Predictive AI Engine", "Allow AI to curate your style drops", _aiPredictiveStyling, (v) => setState(() => _aiPredictiveStyling = v), Icons.auto_awesome_outlined),
            _buildSettingTile("Anonymous Analytics", "Share data without identity tracking", _anonymousTracking, (v) => setState(() => _anonymousTracking = v), Icons.vpn_lock_outlined),
            const SizedBox(height: 48),
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Text("VAULT SETTINGS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2));
  }

  Widget _buildSettingTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassmorphicContainer(
        width: double.infinity, height: 80, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white38, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(subtitle, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value, onChanged: onChanged,
                activeColor: AppTheme.accentColor,
                activeTrackColor: AppTheme.accentColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("DANGER ZONE", style: GoogleFonts.outfit(color: Colors.redAccent.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.redAccent, content: Text("Security Protocol initiated. AI Style Profile deactivation pending...", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.redAccent.withOpacity(0.2))),
            child: Row(
              children: [
                const Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 20),
                const SizedBox(width: 16),
                Text("Deactivate Style Profile", style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
