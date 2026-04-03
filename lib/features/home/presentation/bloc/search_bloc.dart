import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchEvent {
  final String query;
  const PerformSearch(this.query);
  @override
  List<Object?> get props => [query];
}

// States
abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final List<ProductEntity> results;
  final String aiReasoning;

  const SearchLoaded({
    required this.query,
    required this.results,
    required this.aiReasoning,
  });

  @override
  List<Object?> get props => [query, results, aiReasoning];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<PerformSearch>((event, emit) async {
      emit(SearchLoading());
      try {
        // Simulate AI Brain processing the NLP query
        await Future.delayed(const Duration(milliseconds: 1800));
        
        final allMockProducts = [
          const ProductEntity(
            id: '201',
            name: 'Jet-Set Sneaker',
            imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80',
            price: 5500.0,
            category: 'Footwear',
            matchScore: 0.98,
            isTrending: true,
          ),
          const ProductEntity(
            id: '202',
            name: 'Onyx Duffel Bag',
            imageUrl: 'https://images.unsplash.com/photo-1547949003-9792a18a2601?auto=format&fit=crop&q=80',
            price: 12000.0,
            category: 'Accessories',
            matchScore: 0.94,
            isTrending: false,
          ),
          const ProductEntity(
            id: '203',
            name: 'Luxe Bluetooth Speaker',
            imageUrl: 'https://images.unsplash.com/photo-1608156639585-34052e81c99f?auto=format&fit=crop&q=80',
            price: 8500.0,
            category: 'Audio',
            matchScore: 0.91,
            isTrending: true,
          ),
          const ProductEntity(
            id: '204',
            name: 'Minimalist Card Holder',
            imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&q=80',
            price: 2500.0,
            category: 'Accessories',
            matchScore: 0.89,
            isTrending: false,
          ),
        ];

        // Basic mock filtering logic
        List<ProductEntity> filtered = allMockProducts;
        String reasoning = "Based on your style persona and recent interests.";

        if (event.query.contains("Gift")) {
          filtered = [allMockProducts[1], allMockProducts[2]];
          reasoning = "Curated premium gift items with high satisfaction scores.";
        } else if (event.query.contains("Shoes")) {
          filtered = [allMockProducts[0]];
          reasoning = "Top-rated comfort and aesthetic matches for your profile.";
        }

        emit(SearchLoaded(
          query: event.query,
          results: filtered,
          aiReasoning: reasoning,
        ));
      } catch (e) {
        emit(const SearchError("AI search brain is recalibrating. Try again."));
      }
    });
  }
}
