import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

// Home Event
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadRecommendations extends HomeEvent {}

class FilterByCategory extends HomeEvent {
  final String category;
  const FilterByCategory(this.category);
  @override
  List<Object?> get props => [category];
}

// Home State
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<ProductEntity> personalized;
  final List<ProductEntity> trending;
  final List<String> categories;
  final String selectedCategory;
  final List<ProductEntity> flashDrops;
  final List<Map<String, dynamic>> aiBundles;
  final List<String> commandPills;
  final List<Map<String, dynamic>> socialFeed;
  
  // Hidden from UI but used for filtering logic
  final List<ProductEntity> _fullPersonalized;
  final List<ProductEntity> _fullTrending;

  const HomeLoaded({
    required this.personalized, 
    required this.trending, 
    required this.categories,
    this.selectedCategory = 'All',
    required this.flashDrops,
    required this.aiBundles,
    required this.commandPills,
    required this.socialFeed,
    required List<ProductEntity> fullPersonalized,
    required List<ProductEntity> fullTrending,
  }) : _fullPersonalized = fullPersonalized, _fullTrending = fullTrending;

  @override
  List<Object?> get props => [
    personalized, trending, categories, selectedCategory, 
    flashDrops, aiBundles, commandPills, socialFeed
  ];

  HomeLoaded copyWith({
    List<ProductEntity>? personalized,
    List<ProductEntity>? trending,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      personalized: personalized ?? this.personalized,
      trending: trending ?? this.trending,
      categories: categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      flashDrops: flashDrops,
      aiBundles: aiBundles,
      commandPills: commandPills,
      socialFeed: socialFeed,
      fullPersonalized: _fullPersonalized,
      fullTrending: _fullTrending,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object?> get props => [message];
}

// Home BLoC Logic
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadRecommendations>((event, emit) async {
      emit(HomeLoading());
      try {
        // Simulate AI Brain processing...
        await Future.delayed(const Duration(milliseconds: 2200));
        
        final allProducts = [
          const ProductEntity(
            id: '1',
            name: 'Midnight Onyx Watch',
            imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80',
            price: 1800.0,
            category: 'Watches',
            matchScore: 0.98,
            isTrending: true,
          ),
          const ProductEntity(
            id: '2',
            name: 'Crystal Sound Buds',
            imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80',
            price: 1200.0,
            category: 'Audio',
            matchScore: 0.92,
            isTrending: false,
          ),
          const ProductEntity(
            id: '3',
            name: 'Arctic Parka V2',
            imageUrl: 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&q=80',
            price: 2500.0,
            category: 'Apparel',
            matchScore: 0.85,
            isTrending: true,
          ),
          const ProductEntity(
            id: '5',
            name: 'Aurora Smart Ring',
            imageUrl: 'https://images.unsplash.com/photo-1617043786394-f977fa12eddf?auto=format&fit=crop&q=80',
            price: 900.0,
            category: 'Tech',
            matchScore: 0.95,
            isTrending: true,
          ),
        ];

        emit(HomeLoaded(
          personalized: allProducts.where((p) => p.matchScore > 0.9).toList(),
          trending: allProducts.where((p) => p.isTrending).toList(),
          fullPersonalized: allProducts.where((p) => p.matchScore > 0.9).toList(),
          fullTrending: allProducts.where((p) => p.isTrending).toList(),
          selectedCategory: 'All',
          categories: ['All', 'Watches', 'Audio', 'Apparel', 'Tech'],
          flashDrops: [allProducts[0], allProducts[3]],
          commandPills: ["Find Gift for Techie", "Black Shoes < ₹2000", "Winter Essentials", "Latest Tech"],
          aiBundles: [
            {
              "title": "Midnight Executive",
              "items": [allProducts[0], allProducts[1]],
              "price": 2800.0,
              "image": "https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80",
            }
          ],
          socialFeed: [
            {"user": "Alex_Lux", "avatar": "https://i.pravatar.cc/150?u=1", "comment": "This watch is mindblowing!", "image": allProducts[0].imageUrl},
            {"user": "Sarah_Tech", "avatar": "https://i.pravatar.cc/150?u=2", "comment": "The crystal buds are so sleek.", "image": allProducts[1].imageUrl},
          ],
        ));
      } catch (e) {
        emit(const HomeError(message: "Failed to optimize your luxury feed"));
      }
    });

    on<FilterByCategory>((event, emit) async {
      if (state is HomeLoaded) {
        final current = state as HomeLoaded;
        
        // Simulate "AI Optimization" rethink time
        // emit(HomeLoading()); // Optional: could show a partial loading or pulse
        
        final filteredPersonalized = event.category == 'All' 
          ? current._fullPersonalized 
          : current._fullPersonalized.where((p) => p.category == event.category).toList();
          
        final filteredTrending = event.category == 'All' 
          ? current._fullTrending 
          : current._fullTrending.where((p) => p.category == event.category).toList();

        emit(current.copyWith(
          personalized: filteredPersonalized,
          trending: filteredTrending,
          selectedCategory: event.category,
        ));
      }
    });
  }
}

