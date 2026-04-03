import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AIConciergePage extends StatefulWidget {
  const AIConciergePage({super.key});

  @override
  State<AIConciergePage> createState() => _AIConciergePageState();
}

class _AIConciergePageState extends State<AIConciergePage> {
  final List<Map<String, dynamic>> _messages = [
    {'isAI': true, 'text': 'Hello! I am your Smart Selects Assistant. How can I help you elevate your style today?'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add({'isAI': false, 'text': _controller.text});
      _controller.clear();
    });
    
    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({'isAI': true, 'text': 'Analyzing your profile... I recommend checking the new Cyberpunk Tech Boots for a perfect match.'});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageBubble(_messages[index], index),
            ),
          ),
          _buildSuggestedChips(),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      title: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("AI CONCIERGE", style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text("Online • Powered by SmartSelects", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, int index) {
    final bool isAI = msg['isAI'];
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: BoxConstraints(minHeight: 50, maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: (isAI ? Colors.white.withOpacity(0.05) : AppTheme.accentColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: (isAI ? Colors.white.withOpacity(0.1) : AppTheme.accentColor.withOpacity(0.3))),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(msg['text'] as String, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, height: 1.4)),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (200 * index).ms).slideX(begin: isAI ? -0.1 : 0.1, end: 0);
  }

  Widget _buildSuggestedChips() {
    final suggestions = ["Where is my order?", "Refine my style profile", "Latest drops for me"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: suggestions.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => setState(() => _messages.add({'isAI': false, 'text': suggestions[index]})),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
              alignment: Alignment.center,
              child: Text(suggestions[index], style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GlassmorphicContainer(
        width: double.infinity, height: 60, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(hintText: "Ask AI Assistant...", hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14), border: InputBorder.none),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(icon: const Icon(Icons.send_rounded, color: AppTheme.accentColor, size: 20), onPressed: _sendMessage),
            ],
          ),
        ),
      ),
    );
  }
}
