import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class VoiceSearchOverlay extends StatefulWidget {
  const VoiceSearchOverlay({super.key});

  @override
  State<VoiceSearchOverlay> createState() => _VoiceSearchOverlayState();
}

class _VoiceSearchOverlayState extends State<VoiceSearchOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  String _transcription = "Listening...";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    
    // Simulate transcription
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _transcription = "Looking for neon tactical boots...");
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() {
        _transcription = "Under ₹ 10,000 for Summer Drop...";
        _isProcessing = true;
      });
    });
    Future.delayed(const Duration(seconds: 6), () {
       if (mounted) Navigator.pop(context); // Close after simulation
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlassmorphicContainer(
        width: double.infinity, height: double.infinity, borderRadius: 0, blur: 30, border: 0, alignment: Alignment.center,
        linearGradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.95)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.transparent]),
        child: Stack(
          children: [
            _buildCloseButton(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedWaveform(),
                  const SizedBox(height: 60),
                  _buildTranscriptionArea(),
                  const SizedBox(height: 40),
                  if (_isProcessing) _buildAIThinkingPulse(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 60, right: 24,
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAnimatedWaveform() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing Rings
        ...List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              double progress = (_waveController.value + (i * 0.33)) % 1.0;
              return Container(
                width: 100 + (progress * 150), height: 100 + (progress * 150),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.accentColor.withOpacity(1 - progress), width: 2)),
              );
            },
          );
        }),
        // Mic Icon
        Container(
          width: 90, height: 90,
          decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTheme.accentColor, blurRadius: 30, spreadRadius: 5)]),
          child: const Icon(Icons.mic_none_outlined, color: Colors.black, size: 40),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
      ],
    );
  }

  Widget _buildTranscriptionArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text("AI CONVERSATIONAL SEARCH", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3)),
          const SizedBox(height: 16),
          Text(
            _transcription,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
          ).animate(key: ValueKey(_transcription)).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildAIThinkingPulse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
        ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 600.ms, delay: (i * 200).ms, curve: Curves.easeInOut).fadeOut();
      }),
    );
  }
}
