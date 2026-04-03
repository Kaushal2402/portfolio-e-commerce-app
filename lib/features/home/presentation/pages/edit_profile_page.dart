import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: "Alex Harrison");
  final _bioController = TextEditingController(text: "AI Style Enthusiast & Tech Explorer. Passionate about avant-garde fashion and smart commerce.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("EDIT PROFILE", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("SAVE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 40),
            _buildTextField("Full Name", _nameController, Icons.person_outline),
            const SizedBox(height: 24),
            _buildTextField("Bio", _bioController, Icons.description_outlined, maxLines: 3),
            const SizedBox(height: 32),
            _buildSectionHeader("STYLE PREFERENCES"),
            const SizedBox(height: 16),
            _buildStyleChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 2)),
            child: const CircleAvatar(radius: 60, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80')),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 20),
          ),
        ],
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 12),
        GlassmorphicContainer(
          width: double.infinity, height: maxLines == 1 ? 60 : 120, borderRadius: 16, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                icon: Icon(icon, color: Colors.white24, size: 20),
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final List<String> _selectedStyles = ["Minimalist", "Techwear"];

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI Recommendation Engine: Updating Style Persona...")),
            );
          },
          child: Text("MANAGE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStyleChips() {
    final styles = ["Minimalist", "Cyberpunk", "Streetwear", "Techwear", "Avant-Garde"];
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: styles.map((s) => _styleChip(s)).toList(),
    );
  }

  Widget _styleChip(String label) {
    final bool isSelected = _selectedStyles.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedStyles.remove(label);
          } else {
            _selectedStyles.add(label);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor.withOpacity(0.1) : Colors.white.withOpacity(0.05), 
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(color: isSelected ? AppTheme.accentColor.withOpacity(0.5) : Colors.white.withOpacity(0.1)),
        ),
        child: Text(label, style: GoogleFonts.outfit(color: isSelected ? AppTheme.accentColor : Colors.white70, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
