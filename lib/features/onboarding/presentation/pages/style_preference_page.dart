import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/onboarding_bloc.dart';

class StylePreferencePage extends StatelessWidget {
  const StylePreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const StylePreferenceView(),
    );
  }
}

class StylePreferenceView extends StatelessWidget {
  const StylePreferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.isComplete) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background Glow
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentColor.withOpacity(0.05),
                  ),
                ).animate().scale(duration: 1000.ms),
              ),
              
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(state),
                      const SizedBox(height: 48),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _buildCurrentStep(context, state),
                        ),
                      ),
                      _buildFooter(context, state),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(OnboardingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Step ${state.currentStep + 1} of 3",
                style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {}, // Skip functionality
              child: Text("Skip", style: GoogleFonts.outfit(color: Colors.white38)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          _getStepTitle(state.currentStep),
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          _getStepSubtitle(state.currentStep),
          style: GoogleFonts.outfit(color: Colors.white60, fontSize: 16),
        ),
      ],
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return "Personalize Your Style";
      case 1: return "Choose Your Aesthetic";
      case 2: return "Define Your Budget";
      default: return "";
    }
  }

  String _getStepSubtitle(int step) {
    switch (step) {
      case 0: return "What describes your vibe?";
      case 1: return "How do you want your store to look?";
      case 2: return "We match products to your price range.";
      default: return "";
    }
  }

  Widget _buildCurrentStep(BuildContext context, OnboardingState state) {
    switch (state.currentStep) {
      case 0: return _buildOptions(context, ["Minimalist", "Avant-Garde", "Classic Luxury", "Street Sport"]);
      case 1: return _buildOptions(context, ["Midnight Lux", "Crystal Glass", "Golden Warmth", "Neon Cyber"]);
      case 2: return _buildOptions(context, ["Affordable", "Premium", "Elite (Ultra-Lux)"]);
      default: return const SizedBox();
    }
  }

  Widget _buildOptions(BuildContext context, List<String> options) {
    return ListView.separated(
      key: ValueKey(options.length),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildSelectableCard(context, options[index], index);
      },
    );
  }

  Widget _buildSelectableCard(BuildContext context, String title, int index) {
    return GestureDetector(
      onTap: () {
        final bloc = context.read<OnboardingBloc>();
        if (bloc.state.currentStep == 0) bloc.add(SelectStyle(title));
        else if (bloc.state.currentStep == 1) bloc.add(SelectAesthetic(title));
        else if (bloc.state.currentStep == 2) bloc.add(SelectBudget(title));
      },
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 15,
        alignment: Alignment.centerLeft,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildFooter(BuildContext context, OnboardingState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: state.currentStep == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: state.currentStep == index ? AppTheme.accentColor : Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Text(
          "Our AI will customize the store experience for you.",
          style: GoogleFonts.outfit(color: Colors.white24, fontSize: 12),
        ),
      ],
    );
  }
}
