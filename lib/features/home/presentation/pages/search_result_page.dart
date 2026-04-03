import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/search_bloc.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class SearchResultPage extends StatelessWidget {
  final String query;
  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(PerformSearch(query)),
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("AI Search", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return _buildLoadingState();
            } else if (state is SearchLoaded) {
              return _buildResultsState(context, state);
            } else if (state is SearchError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.accentColor.withOpacity(0.1)),
            child: const CircularProgressIndicator(color: AppTheme.accentColor),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1000.ms),
          const SizedBox(height: 24),
          Text(
            "Analyzing criteria...", 
            style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 16, letterSpacing: 2),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms),
        ],
      ),
    );
  }

  Widget _buildResultsState(BuildContext context, SearchLoaded state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQueryHeader(state.query),
                const SizedBox(height: 16),
                _buildAIReasoningCard(state.aiReasoning),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildResultCard(context, state.results[index]).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
              },
              childCount: state.results.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildQueryHeader(String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SEARCHING FOR",
          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 4),
        Text(
          "\"$query\"",
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }

  Widget _buildAIReasoningCard(String reasoning) {
    return GlassmorphicContainer(
      width: double.infinity, height: 80, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
      borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.3), Colors.transparent]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 20),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                reasoning,
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12, height: 1.4),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildResultCard(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: SmartImage(imageUrl: product.imageUrl, width: double.infinity, height: double.infinity),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "${(product.matchScore * 100).toInt()}% Match",
                        style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1),
                  const SizedBox(height: 4),
                  Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
