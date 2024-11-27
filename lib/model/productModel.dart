import 'package:flutter/material.dart';

class ProductRepository extends ChangeNotifier {
  final List<Map<String, dynamic>> _addedProducts = [];

  List<Map<String, dynamic>> get addedProducts => _addedProducts;

  void addProduct(Map<String, dynamic> product) {
    _addedProducts.add(product);
    notifyListeners(); // Notify listeners to rebuild UI
  }

 void editProduct(int index, Map<String, dynamic> updatedProduct) {
  _addedProducts[index] = updatedProduct;
  notifyListeners(); // Notify listeners to rebuild UI
}

  void deleteProduct(int index) {
    _addedProducts.removeAt(index);
    notifyListeners(); // Notify listeners to rebuild UI
  }
}

// Define the Product model
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

// Example list of products (menu)
List<Product> menu = [
  Product(name: 'Snickers Iced Coffee', price: 130.0),
  Product(name: 'Marshmallow Iced Coffee', price: 125.0),
  Product(name: 'Double Caramel Macchiato', price: 120.0),
  Product(name: 'Ube Iced Coffee', price: 120.0),
  Product(name: 'Brown Sugar Iced Coffee', price: 120.0),
  Product(name: 'Caramel White Mocha', price: 120.0),
];
