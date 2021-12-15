import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './product.dart';

class Products with ChangeNotifier {
  late List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Levi\'s Shirt',
    //   description: 'A colorful shirt!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.aboutstatic.com/file/38dbc7b304cadb1c226e4fcce466cf0c?width=400&quality=75&bg=F4F4F5',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://www.lochcarron.co.uk/media/catalog/product/cache/1/image/6394c83a75c69a6a4e83af5187d85618/t/g/tggtrr-custom-mens-reiver-tartan-trousers1-front-72dpi-rgb_1.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://fir-shop-5d545-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        loadedProducts.add(
          Product(
              id: prodID,
              description: prodData['description'],
              imageURL: prodData['imageURL'],
              price: prodData['price'],
              title: prodData['title'],
              isFavorite: prodData['isFavorite']),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://fir-shop-5d545-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageURL': product.imageURL,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          imageURL: product.imageURL,
          price: product.price,
          title: product.title);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodInedx = _items.indexWhere((prod) => prod.id == id);
    if (prodInedx >= 0) {
      final url = Uri.parse(
          'https://fir-shop-5d545-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageURL': newProduct.imageURL,
          }));
      _items[prodInedx] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productID) {
    _items.removeWhere((prod) => prod.id == productID);
    notifyListeners();
  }
}
