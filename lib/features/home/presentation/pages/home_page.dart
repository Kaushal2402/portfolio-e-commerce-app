import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/home_bloc.dart';
import 'package:smart_commerce/features/home/presentation/pages/voice_search_overlay.dart';
import 'package:smart_commerce/features/home/presentation/pages/ai_concierge_page.dart';
import '../../domain/entities/product_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'collection_page.dart';
import 'search_result_page.dart';
import 'flash_drop_page.dart';
import 'product_detail_page.dart';
import 'bundle_detail_page.dart';
import 'style_board_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import '../../../../core/widgets/smart_image.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadRecommendations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -100, right: -100, child: _glow(400, AppTheme.accentColor.withOpacity(0.05))),
          Positioned(bottom: 200, left: -100, child: _glow(300, Colors.blue.withOpacity(0.03))),
          
          SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(),
                    _buildHeroParallax(),
                    _buildSearchBar(),
                    if (state is HomeLoading)
                      const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.accentColor)))
                    else if (state is HomeLoaded) ...[
                      _buildCommandPills(state.commandPills),
                      _buildCategories(state.categories, state.selectedCategory),
                      _buildSectionHeader("Limited Flash Drops", isLive: true, onSeeAll: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashDropPage()));
                      }),
                      _buildFlashDrops(state.flashDrops),
                      _buildSectionHeader("Personalized For You"),
                      _buildForYouSection(state.personalized),
                      _buildSectionHeader("AI-Curated Bundles"),
                      _buildBundleSection(state.aiBundles),
                      _buildSectionHeader("Social Style Board"),
                      _buildSocialFeed(state.socialFeed),
                      _buildSectionHeader("Trending Now"),
                      _buildTrendingSection(state.trending),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ] else ...[
                      const SliverToBoxAdapter(child: SizedBox()),
                    ],
                  ],
                );
              },
            ),
          ),
          
          _buildBottomNavBar(),
          _buildAIConciergeFAB(),
        ],
      ),
    );
  }

  Widget _buildAIConciergeFAB() {
    return Positioned(
      bottom: 100, right: 24,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIConciergePage())),
        child: GlassmorphicContainer(
          width: 56, height: 56, borderRadius: 28, blur: 10, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.8), AppTheme.accentColor]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.5), Colors.transparent]),
          child: const Icon(Icons.auto_awesome, color: Colors.black, size: 24),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms, color: Colors.white38),
      ),
    ).animate().scale(delay: 1000.ms, duration: 600.ms, curve: Curves.easeOutBack).fadeIn();
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ).animate().fadeIn(duration: 1000.ms);
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Hello, User", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16)),
                    const SizedBox(width: 8),
                    _buildAIStatusPulse(),
                  ],
                ),
                Text("Smart Selects", style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage())),
              child: _iconButton(Icons.notifications_outlined),
            ),
          ],
        ),
      ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms).fadeIn(),
    );
  }

  Widget _buildAIStatusPulse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle))
            .animate(onPlay: (c) => c.repeat())
            .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1000.ms)
            .fadeOut(duration: 1000.ms),
          const SizedBox(width: 4),
          Text("AI ENGINE ACTIVE", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white10, width: 1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildHeroParallax() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CollectionPage(collectionId: 'summer-drop')),
            );
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Hero(
                    tag: 'hero-banner',
                    child: SmartImage(
                      imageUrl: "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?auto=format&fit=crop&q=80",
                      width: double.infinity, height: double.infinity,
                    ),
                  ),
                ),
                GlassmorphicContainer(
                  width: double.infinity, height: 200, borderRadius: 32, blur: 5, border: 1,
                  alignment: Alignment.center,
                  linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.4), Colors.transparent]),
                  borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent]),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SUMMER DROP '26", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3)),
                        const SizedBox(height: 8),
                        Text("Ethereal\nCollection", style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.1)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Text("Explore Now", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(begin: const Offset(0.95, 0.95), duration: 800.ms, curve: Curves.easeOutBack),
      ),
    );
  }


  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: GlassmorphicContainer(
          width: double.infinity, height: 60, borderRadius: 20, blur: 20, border: 1, alignment: Alignment.center,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white38, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchResultPage(query: ""))),
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(hintText: "Search your style...", hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14), border: InputBorder.none),
                  ),
                ),
                VerticalDivider(color: Colors.white.withOpacity(0.1), indent: 15, endIndent: 15),
                IconButton(
                  icon: const Icon(Icons.mic_none_outlined, color: AppTheme.accentColor, size: 22),
                  onPressed: () {
                    showGeneralDialog(
                      context: context, pageBuilder: (context, _, __) => const VoiceSearchOverlay(),
                      transitionDuration: const Duration(milliseconds: 400),
                      barrierDismissible: true, barrierLabel: "Voice Search",
                      barrierColor: Colors.black.withOpacity(0.5),
                    );
                  },
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildCommandPills(List<String> pills) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: pills.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResultPage(query: pills[index])),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
                  alignment: Alignment.center,
                  child: Text("✦ ${pills[index]}", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategories(List<String> categories, String selectedCategory) {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(FilterByCategory(category));
                },
                child: GlassmorphicContainer(
                  width: 100, height: 40, borderRadius: 20, blur: 10, border: 1, alignment: Alignment.center,
                  linearGradient: LinearGradient(colors: isSelected ? [AppTheme.accentColor.withOpacity(0.3), AppTheme.accentColor.withOpacity(0.1)] : [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]),
                  borderGradient: LinearGradient(colors: isSelected ? [AppTheme.accentColor.withOpacity(0.5), AppTheme.accentColor.withOpacity(0.2)] : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
                  child: Text(category, style: GoogleFonts.outfit(color: isSelected ? AppTheme.accentColor : Colors.white60, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
                ),
              ),
            );
          },
        ),
      ).animate().fadeIn(delay: 300.ms),
    );
  }

  Widget _buildSectionHeader(String title, {bool isLive = false, VoidCallback? onSeeAll}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                if (isLive) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text("LIVE", style: GoogleFonts.outfit(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms),
                ]
              ],
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: Text("See All", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 14)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashDrops(List<ProductEntity> products) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
              },
              child: Container(
                width: 300, margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24), 
                      child: SmartImage(imageUrl: product.imageUrl, width: double.infinity, height: double.infinity),
                    ),
                    GlassmorphicContainer(
                      width: double.infinity, height: 200, borderRadius: 24, blur: 2, border: 1,
                      alignment: Alignment.bottomLeft,
                      linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text("Ends in 02:45:12", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _iconButton(Icons.bolt),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForYouSection(List<ProductEntity> products) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 320,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
              },
              child: Container(
                width: 220, margin: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildForYouCard(product),
              ).animate().fadeIn(delay: (index * 150).ms).slideX(begin: 0.1, end: 0),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForYouCard(ProductEntity product) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.secondaryColor, borderRadius: BorderRadius.circular(24)),
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
                Positioned(top: 12, left: 12, child: _matchBadge(product.matchScore)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: AppTheme.accentColor, content: Text("${product.name} added to Smart Cart", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold))),
                        );
                      },
                      child: const Icon(Icons.add_shopping_cart, color: Colors.white70, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchBadge(double score) {
    return GlassmorphicContainer(
      width: 70, height: 28, borderRadius: 10, blur: 5, border: 0.5, alignment: Alignment.center,
      linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.3)]),
      borderGradient: LinearGradient(colors: [AppTheme.accentColor.withOpacity(0.5), Colors.transparent]),
      child: Text("${(score * 100).toInt()}% Match", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBundleSection(List<Map<String, dynamic>> bundles) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: bundles.length,
          itemBuilder: (context, index) {
            final bundle = bundles[index];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BundleDetailPage(bundle: bundle))),
              child: Container(
                width: 320, margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), image: DecorationImage(image: CachedNetworkImageProvider(bundle['image']), fit: BoxFit.cover)),
                child: GlassmorphicContainer(
                  width: 320, height: 220, borderRadius: 24, blur: 0, border: 1, alignment: Alignment.center,
                  linearGradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("COMPLETE THE LOOK", style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        Text(bundle['title'], style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Full Set only ₹ ${bundle['price'].toInt()}", style: GoogleFonts.outfit(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialFeed(List<Map<String, dynamic>> feed) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: feed.length,
          itemBuilder: (context, index) {
            final item = feed[index];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StyleBoardPage(item: item))),
              child: Container(
                width: 280, margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12), 
                    child: SmartImage(imageUrl: item['image'], width: 80, height: 80),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 8, backgroundImage: CachedNetworkImageProvider(item['avatar'])),
                            const SizedBox(width: 6),
                            Text(item['user'], style: GoogleFonts.outfit(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item['comment'], style: GoogleFonts.outfit(color: Colors.white, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        ),
      ),
    );
  }

  Widget _buildTrendingSection(List<ProductEntity> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return _productGridItem(product)
                .animate()
                .fadeIn(delay: (index * 100).ms)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _productGridItem(ProductEntity product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(color: AppTheme.secondaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), 
                child: SmartImage(imageUrl: product.imageUrl, width: double.infinity, height: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1),
                  Text("₹ ${product.price.toInt()}", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 24, left: 24, right: 24,
      child: GlassmorphicContainer(
        width: double.infinity, height: 70, borderRadius: 24, blur: 20, border: 1, alignment: Alignment.center,
        linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
        borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.home_filled, "Home", true),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchResultPage(query: ""))),
              child: _navItem(Icons.explore_outlined, "Explore", false),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
              child: _navItem(Icons.shopping_cart_outlined, "Cart", false),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
              child: _navItem(Icons.person_outline, "Profile", false),
            ),
          ],
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutCirc),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? AppTheme.accentColor : Colors.white60, size: 28),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4), width: 4, height: 4,
            decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
          ),
      ],
    );
  }
}
