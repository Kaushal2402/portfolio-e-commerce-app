import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("ADD NEW ADDRESS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField("Location Label (e.g. Home, Work)", _labelController, Icons.label_outline),
            const SizedBox(height: 24),
            _buildTextField("Full Address", _addressController, Icons.location_on_outlined, maxLines: 3),
            const SizedBox(height: 48),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 12),
        GlassmorphicContainer(
          width: double.infinity, height: maxLines == 1 ? 60 : 120, borderRadius: 16, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller, maxLines: maxLines,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(icon: Icon(icon, color: Colors.white24, size: 20), border: InputBorder.none, hintStyle: const TextStyle(color: Colors.white24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 60, width: double.infinity,
        decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text("SAVE ADDRESS", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2))),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
