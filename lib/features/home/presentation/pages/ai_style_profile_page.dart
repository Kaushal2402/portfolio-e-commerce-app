import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AIStyleProfilePage extends StatefulWidget {
  const AIStyleProfilePage({super.key});

  @override
  State<AIStyleProfilePage> createState() => _AIStyleProfilePageState();
}

class _AIStyleProfilePageState extends State<AIStyleProfilePage> {
  double _oversizedValue = 0.7;
  double _experimentalValue = 0.9;

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
            _buildDnaCard(),
            const SizedBox(height: 32),
            _buildSliderSection("FIT PREFERENCE (OVERSIZED)", _oversizedValue, (v) => setState(() => _oversizedValue = v)),
            const SizedBox(height: 24),
            _buildSliderSection("DESIGN COMPLEXITY", _experimentalValue, (v) => setState(() => _experimentalValue = v)),
            const SizedBox(height: 40),
            Text("AI CURATED ARCHIVE", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 16),
            _buildArchiveGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Text("AI STYLE PROFILE", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _buildDnaCard() {
    return GlassmorphicContainer(
      width: double.infinity, height: 140, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)]),
      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(Icons.auto_fix_high, color: AppTheme.accentColor, size: 40).animate().shimmer(),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("STYLE DNA: TECH-MINIMAL", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Based on 42 recent AI interactions", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.accentColor, inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white, overlayColor: AppTheme.accentColor.withOpacity(0.2),
            trackHeight: 2,
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildArchiveGrid() {
    final images = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1529139512842-b98a2824cd4a?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80',
    ];

    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(images[index]), fit: BoxFit.cover),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.6), Colors.transparent])),
            alignment: Alignment.bottomCenter, padding: const EdgeInsets.all(8),
            child: Text("DROP 0${index + 1}", style: GoogleFonts.outfit(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ).animate().fadeIn(delay: (50 * index).ms).scale(duration: 400.ms);
      },
    );
  }
}
