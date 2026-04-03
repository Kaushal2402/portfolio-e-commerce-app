import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'walkthrough_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate initial loading (e.g., config fetch, auth check)
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const WalkthroughPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.08),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2000.ms, curve: Curves.easeInOut),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minimalist Luxury Logo Placeholder
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(
                    Icons.auto_awesome, 
                    color: AppTheme.accentColor, 
                    size: 60,
                  ),
                ).animate()
                 .fadeIn(duration: 800.ms)
                 .scale(duration: 800.ms, curve: Curves.elasticOut)
                 .shimmer(delay: 1500.ms, duration: 1500.ms, color: Colors.white24),
                
                const SizedBox(height: 24),
                
                Text(
                  "S M A R T",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w300,
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 8),
                
                Text(
                  "COMMERCE",
                  style: GoogleFonts.outfit(
                    color: AppTheme.accentColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 60),
                
                // Loading Indicator
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      color: AppTheme.accentColor,
                      minHeight: 1,
                    ),
                  ),
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
          
          // Bottom Tagline
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Personalized Intelligence",
                style: GoogleFonts.outfit(
                  color: Colors.white24,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(delay: 1500.ms),
            ),
          ),
        ],
      ),
    );
  }
}
