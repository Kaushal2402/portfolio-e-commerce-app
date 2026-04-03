import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/collection_bloc.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class CollectionPage extends StatelessWidget {
  final String collectionId;
  const CollectionPage({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionBloc()..add(LoadCollection(collectionId)),
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: BlocBuilder<CollectionBloc, CollectionState>(
          builder: (context, state) {
            if (state is CollectionLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.accentColor));
            } else if (state is CollectionLoaded) {
              return _buildContent(context, state);
            } else if (state is CollectionError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CollectionLoaded state) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, state),
        _buildFilterBar(),
        _buildProductList(state.products),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CollectionLoaded state) {
    return SliverAppBar(
      expandedHeight: 400.0,
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero-banner',
              child: SmartImage(
                imageUrl: state.imageUrl,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.primaryColor,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CURATED FOR YOU",
                    style: GoogleFonts.outfit(
                      color: AppTheme.accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  Text(
                    state.title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _filterChip("All Items", true),
              _filterChip("Sort by Match", false),
              _filterChip("Price: Low-High", false),
              _filterChip("Premium Only", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GlassmorphicContainer(
        width: 120,
        height: 38,
        borderRadius: 20,
        blur: 10,
        border: 1,
        alignment: Alignment.center,
        linearGradient: LinearGradient(
          colors: isSelected 
            ? [AppTheme.accentColor.withOpacity(0.3), AppTheme.accentColor.withOpacity(0.1)] 
            : [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
        ),
        borderGradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.15), Colors.transparent],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? AppTheme.accentColor : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductEntity> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildProductTile(context, product),
            ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
      },
      child: Container(
        height: 155,
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SmartImage(
                  imageUrl: product.imageUrl,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                product.category.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _matchScoreBadge(product.matchScore),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹ ${product.price.toInt()}",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: AppTheme.accentColor, content: Text("${product.name} added to Smart Cart", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.black, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchScoreBadge(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${(score * 100).toInt()}% Match",
        style: GoogleFonts.outfit(
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
