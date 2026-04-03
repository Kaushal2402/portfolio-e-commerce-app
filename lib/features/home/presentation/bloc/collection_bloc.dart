import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

// Events
abstract class CollectionEvent extends Equatable {
  const CollectionEvent();
  @override
  List<Object?> get props => [];
}

class LoadCollection extends CollectionEvent {
  final String collectionId;
  const LoadCollection(this.collectionId);
  @override
  List<Object?> get props => [collectionId];
}

// States
abstract class CollectionState extends Equatable {
  const CollectionState();
  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}
class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final String title;
  final String imageUrl;
  final List<ProductEntity> products;

  const CollectionLoaded({
    required this.title,
    required this.imageUrl,
    required this.products,
  });

  @override
  List<Object?> get props => [title, imageUrl, products];
}

class CollectionError extends CollectionState {
  final String message;
  const CollectionError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(CollectionInitial()) {
    on<LoadCollection>((event, emit) async {
      emit(CollectionLoading());
      try {
        // Simulate high-end data fetching
        await Future.delayed(const Duration(milliseconds: 1500));
        
        final summerProducts = [
          const ProductEntity(
            id: '101',
            name: 'Solar Flare Lens',
            imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&q=80',
            price: 4500.0,
            category: 'Eyewear',
            matchScore: 0.96,
            isTrending: true,
          ),
          const ProductEntity(
            id: '102',
            name: 'Azure Silk Shirt',
            imageUrl: 'https://images.unsplash.com/photo-1596755094514-f8d98573a75a?auto=format&fit=crop&q=80',
            price: 8900.0,
            category: 'Apparel',
            matchScore: 0.92,
            isTrending: true,
          ),
          const ProductEntity(
            id: '103',
            name: 'Sand Dune Chinos',
            imageUrl: 'https://images.unsplash.com/photo-1473963456455-dc04d809139d?auto=format&fit=crop&q=80',
            price: 6500.0,
            category: 'Apparel',
            matchScore: 0.88,
            isTrending: false,
          ),
          const ProductEntity(
            id: '104',
            name: 'Ethereal Sandals',
            imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80',
            price: 3200.0,
            category: 'Footwear',
            matchScore: 0.94,
            isTrending: true,
          ),
        ];

        emit(CollectionLoaded(
          title: "ETHEREAL COLLECTION",
          imageUrl: "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?auto=format&fit=crop&q=80",
          products: summerProducts,
        ));
      } catch (e) {
        emit(const CollectionError("Failed to load curated collection"));
      }
    });
  }
}
