import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;
  bool isAddedToCart;

  Product({
    required this.id,
    required this.description,
    required this.imageURL,
    this.isFavorite = false,
    this.isAddedToCart = false,
    required this.price,
    required this.title,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void toggleAddedToCart() {
    isAddedToCart = !isAddedToCart;
    notifyListeners();
  }
}
