import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'SmartCommerce';
  static const double horizontalPadding = 20.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // UI Sizing
  static const double borderRadius = 16.0;
  static const double glassBlur = 15.0;
}

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final List<String> tags;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.tags,
    required this.description,
  });
}

// Mock Data for AI Personalization Simulation
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Midnight Onyx Watch',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80',
    price: 1800.0,
    category: 'Watches',
    tags: ['luxury', 'black', 'watch'],
    description: 'Minimalist luxury watch with onyx dial.',
  ),
  Product(
    id: '2',
    name: 'Crystal Sound Buds',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80',
    price: 1200.0,
    category: 'Audio',
    tags: ['tech', 'white', 'audio'],
    description: 'High-fidelity audio with glass casing.',
  ),
  Product(
    id: '3',
    name: 'Arctic Parka V2',
    imageUrl: 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&q=80',
    price: 2500.0,
    category: 'Apparel',
    tags: ['snow', 'apparel', 'blue'],
    description: 'Extreme weather parka with sleek fit.',
  ),
  Product(
    id: '4',
    name: 'Matte Leather Boots',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80',
    price: 1500.0,
    category: 'Footwear',
    tags: ['leather', 'boots', 'black'],
    description: 'Premium leather boots for all occasions.',
  ),
];
