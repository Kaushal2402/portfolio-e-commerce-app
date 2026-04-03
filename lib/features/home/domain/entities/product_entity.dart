import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final double matchScore; // AI Match Score (0.0 to 1.0)
  final bool isTrending;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.matchScore = 0.0,
    this.isTrending = false,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, price, category, matchScore, isTrending];
}
