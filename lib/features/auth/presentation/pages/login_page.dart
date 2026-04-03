import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../onboarding/presentation/pages/style_preference_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isOtpSent = false;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  void _handleAction() {
    if (!_isOtpSent) {
      if (_phoneController.text.length < 10) return;
      setState(() => _isOtpSent = true);
    } else {
      // Navigate to Style Preference
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StylePreferencePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100, right: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.accentColor.withOpacity(0.05)),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text("SECURE ACCESS", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4))
                          .animate().fadeIn().slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 12),
                      Text("HELLO AGAIN,", style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1))
                          .animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
                      Text("STYLE EXPLORER", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 18, fontWeight: FontWeight.w300))
                          .animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
                      
                      const Spacer(),
                      
                      // Animated Input Area
                      _buildAnimatedInputArea(),
                      
                      const SizedBox(height: 32),
                      
                      _buildActionButton(),
                      
                      const Spacer(flex: 2),
                      
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text("By continuing, you agree to our AI Privacy Protocol.", style: GoogleFonts.outfit(color: Colors.white12, fontSize: 10))
                              .animate().fadeIn(delay: 1000.ms),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedInputArea() {
    return Column(
      children: [
        // Mobile Input
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutExpo,
          transform: Matrix4.translationValues(0, _isOtpSent ? -20 : 0, 0),
          child: Opacity(
            opacity: _isOtpSent ? 0.4 : 1.0,
            child: _inputField("Mobile Number", _phoneController, Icons.phone_iphone_outlined, isEnabled: !_isOtpSent),
          ),
        ),
        
        // OTP Section (Slides up and fades in)
        if (_isOtpSent)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ENTER 6-DIGIT OTP", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2))
                    .animate().fadeIn().slideY(begin: 1.0, end: 0),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _otpBox(index)),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5, end: 0),
                
                const SizedBox(height: 12),
                Center(child: Text("RESEND OTP IN 00:29", style: GoogleFonts.outfit(color: AppTheme.accentColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)))
                    .animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
      ],
    );
  }

  Widget _inputField(String label, TextEditingController controller, IconData icon, {bool isEnabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 12),
        GlassmorphicContainer(
          width: double.infinity, height: 65, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: controller,
              enabled: isEnabled,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, letterSpacing: 2),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppTheme.accentColor, size: 20),
                border: InputBorder.none,
                hintText: "98xxxxxx12",
                hintStyle: GoogleFonts.outfit(color: Colors.white12, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    return Container(
      width: 45, height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Center(
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.outfit(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 20),
          decoration: const InputDecoration(counterText: "", border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: _handleAction,
      child: Container(
        height: 60, width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Center(
          child: Text(
            _isOtpSent ? "VERIFY & ENTER" : "GET OTP",
            style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
      ),
    ).animate(target: _isOtpSent ? 1 : 0).shimmer(duration: 800.ms, color: Colors.white38);
  }
}
