import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://fir-shop-5d545-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }

  void toggleAddedToCart() {
    isAddedToCart = !isAddedToCart;
    notifyListeners();
  }
}
