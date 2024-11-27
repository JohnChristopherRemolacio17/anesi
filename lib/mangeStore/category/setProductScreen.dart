import 'package:capstone_anesi/mangeStore/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/model/productModel.dart';
import 'package:capstone_anesi/mangeStore/addProduct/addProductScreen.dart';

class SetProductScreen extends StatefulWidget {
  @override
  _SetProductScreenState createState() => _SetProductScreenState();
}

class _SetProductScreenState extends State<SetProductScreen> {
  final List<String> categories = ['Drinks', 'Noodles', 'Meals', 'sub-category'];
  String selectedCategory = 'Drinks';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SET PRODUCT',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selector
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Category',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        selectedCategory.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      _showCategoryDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Product List
            Expanded(
              child: Consumer<ProductRepository>(
                builder: (context, productRepo, child) {
                  final combinedProducts = productRepo.addedProducts;

                  return ListView.builder(
                    itemCount: combinedProducts.length,
                    itemBuilder: (context, index) {
                      final product = combinedProducts[index];

                      return Card(
                        child: ListTile(
                          title: Text(product['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product['price'].toStringAsFixed(2),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  _editProduct(context, index, productRepo);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: () {
                                  _deleteProduct(context, index, productRepo);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Buttons Section
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductScreen(
                            onAdd: (newProduct) {
                              Provider.of<ProductRepository>(context, listen: false)
                                  .addProduct(newProduct);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Add New Product',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // The method to handle editing the product
  void _editProduct(BuildContext context, int index, ProductRepository productRepo) {
    final product = productRepo.addedProducts[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          index: index,
          onSave: (updatedProduct, productIndex) {
            productRepo.editProduct(productIndex, updatedProduct);
          },
          onDelete: (productIndex) {
            productRepo.deleteProduct(productIndex);
          },
        ),
      ),
    );
  }

  // The method to handle deleting the product
  void _deleteProduct(BuildContext context, int index, ProductRepository productRepo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                productRepo.deleteProduct(index); // Delete the product
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Category dialog for selecting categories
  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categories.map((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
