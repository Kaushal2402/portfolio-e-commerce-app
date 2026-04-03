import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../auth/presentation/pages/login_page.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WalkthroughStep> _steps = [
    WalkthroughStep(
      title: "AI CURATED",
      subtitle: "NEURAL SELECTIONS",
      description: "Discover products tailored to your unique style persona using our neural recommendation engine.",
      icon: Icons.auto_awesome,
      color: Colors.amber,
    ),
    WalkthroughStep(
      title: "VOICE-FIRST",
      subtitle: "NATURAL DISCOVERY",
      description: "Find exactly what you're looking for by just asking. Our AI understands natural intent.",
      icon: Icons.mic_none_rounded,
      color: AppTheme.accentColor,
    ),
    WalkthroughStep(
      title: "IMMERSIVE",
      subtitle: "3D HYPER-VIEW",
      description: "Explore every detail with high-fidelity 360° views and interactive AR previews.",
      icon: Icons.threed_rotation,
      color: Colors.blueAccent,
    ),
    WalkthroughStep(
      title: "SECURE",
      subtitle: "ELITE CHECKOUT",
      description: "Enjoy ultra-fast, biometric-secured checkout and real-time AI delivery tracking.",
      icon: Icons.shield_outlined,
      color: Colors.greenAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: 100,
            left: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _steps[_currentPage].color.withOpacity(0.05)),
            ).animate(target: _currentPage.toDouble()).tint(color: _steps[_currentPage].color.withOpacity(0.05)),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _steps.length,
            itemBuilder: (context, index) => _buildPage(_steps[index], index),
          ),

          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildPage(WalkthroughStep step, int index) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Central Graphic
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: step.color.withOpacity(0.2))),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 2000.ms),
              
              Icon(step.icon, color: Colors.white, size: 80)
                  .animate(key: ValueKey(index))
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .shimmer(delay: 800.ms, duration: 1500.ms, color: step.color.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 60),
          
          Text(step.title, style: GoogleFonts.outfit(color: step.color, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 6)).animate(key: ValueKey("title_$index")).fadeIn().slideY(begin: 0.5, end: 0),
          const SizedBox(height: 12),
          Text(step.subtitle, style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)).animate(key: ValueKey("sub_$index")).fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 24),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, height: 1.6),
          ).animate(key: ValueKey("desc_$index")).fadeIn(delay: 400.ms),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 60, left: 40, right: 40,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 32 : 8,
                height: 4, margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: _currentPage == index ? AppTheme.accentColor : Colors.white12, borderRadius: BorderRadius.circular(2)),
              );
            }),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              if (_currentPage < _steps.length - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              }
            },
            child: GlassmorphicContainer(
              width: double.infinity, height: 60, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
              linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
              borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
              child: Text(
                _currentPage == _steps.length - 1 ? "GET STARTED" : "CONTINUE",
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
}

class WalkthroughStep {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  WalkthroughStep({required this.title, required this.subtitle, required this.description, required this.icon, required this.color});
}
