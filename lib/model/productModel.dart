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
