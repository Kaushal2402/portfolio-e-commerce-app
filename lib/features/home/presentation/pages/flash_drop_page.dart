import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/smart_image.dart';
import '../bloc/home_bloc.dart';
import '../../domain/entities/product_entity.dart';
import 'product_detail_page.dart';

class FlashDropPage extends StatelessWidget {
  const FlashDropPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("LIVE FLASH DROPS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return _buildDropGrid(context, state.flashDrops);
          }
          return const Center(child: CircularProgressIndicator(color: AppTheme.accentColor));
        },
      ),
    );
  }

  Widget _buildDropGrid(BuildContext context, List<ProductEntity> drops) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppTheme.accentColor),
                const SizedBox(width: 12),
                Text("HAPPENING NOW", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildDropCard(context, drops[index % drops.length]);
              },
              childCount: 6, // Simulation: Repeating items to fill grid
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildDropCard(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SmartImage(imageUrl: product.imageUrl),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 24, left: 24, right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text("Limited Release • ₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _countdownBadge(),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countdownBadge() {
    return GlassmorphicContainer(
      width: 110, height: 40, borderRadius: 12, blur: 10, border: 1, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.red.withOpacity(0.2), Colors.red.withOpacity(0.1)]),
      borderGradient: LinearGradient(colors: [Colors.red.withOpacity(0.5), Colors.transparent]),
      child: Text("02:14:55", style: GoogleFonts.outfit(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms);
  }
}
