import 'package:capstone_anesi/mangeStore/addProduct/addProductScreen.dart';
import 'package:capstone_anesi/model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SetProductScreen extends StatefulWidget {
  @override
  _SetProductScreenState createState() => _SetProductScreenState();
}

class _SetProductScreenState extends State<SetProductScreen> {
  final List<String> categories = ['Drinks', 'Noodles', 'Meals'];
  String selectedCategory = 'Drinks';

  final List<Map<String, dynamic>> predefinedProducts = [
    {'name': 'Snickers Iced Coffee', 'price': 130.0},
    {'name': 'Marshmallow Iced Coffee', 'price': 125.0},
    {'name': 'Double Caramel Macchiato', 'price': 120.0},
    {'name': 'Ube Iced Coffee', 'price': 120.0},
    {'name': 'Marble Macchiato', 'price': 150.0},
    {'name': 'Brown Sugar Iced Coffee', 'price': 115.0},
    {'name': 'Caramel White Mocha', 'price': 110.0},
    {'name': 'Anesi Iced Coffee', 'price': 105.0},
  ];

  final List<Map<String, dynamic>> addOns = [
    {'name': 'Caramel Drizzle', 'price': 20.0},
    {'name': 'Chocolate Drizzle', 'price': 20.0},
    {'name': 'Brown Sugar Drizzle', 'price': 20.0},
    {'name': 'Anesi House Blend Syrup', 'price': 5.0},
    {'name': 'Vanilla Syrup', 'price': 5.0},
  ];

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
                  final combinedProducts = [
                    ...predefinedProducts,
                    ...productRepo.addedProducts, // Dynamically added products
                  ];

                  return ListView.builder(
                    itemCount: combinedProducts.length,
                    itemBuilder: (context, index) {
                      final product = combinedProducts[index];
                      return Card(
                        child: ListTile(
                          title: Text(product['name']),
                          trailing: Text(
                            product['price'].toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ADD ONS Section
            const SizedBox(height: 16.0),
            const Text(
              'ADD ONS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: addOns.map((addOn) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      addOn['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          addOn['price'].toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                          onPressed: () {
                            // Handle editing the add-on
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
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

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
        );
      },
    );
  }
}
