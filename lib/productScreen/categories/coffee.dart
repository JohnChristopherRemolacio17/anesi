import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/model/productModel.dart';
import 'package:capstone_anesi/productScreen/categories/noodles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';


class Coffee extends StatefulWidget {
  const Coffee({super.key});

  @override
  _CoffeeState createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> predefinedItems = [
    {'name': 'Snickers Iced Coffee', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Marshmallow Iced Coffee', 'price': 125.00, 'category': 'COFFEE'},
  {'name': 'Double Caramel Macchiato', 'price': 120.00, 'category': 'COFFEE'},
  {'name': 'Ube Iced Coffee', 'price': 120.00, 'category': 'COFFEE'},
  {'name': 'Brown Sugar Iced Coffee', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Caramel White Mocha', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Anesi Iced Coffee', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Iced Mocha', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Iced Vanilla Latte', 'price': 120.00, 'category': 'COFFEE'},
  {'name': 'Iced Cappuccino', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Iced Cafe Latte', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Iced Strong Black Coffee', 'price': 130.00, 'category': 'COFFEE'},
  {'name': 'Marble Macchiato', 'price': 115.00, 'category': 'COFFEE'},
  {'name': 'Strawberry Choco', 'price': 110.00, 'category': 'NON-COFFEE'},
  {'name': 'Ube Milk', 'price': 110.00, 'category': 'NON-COFFEE'},
  {'name': 'Strawberry Milk', 'price': 100.00, 'category': 'NON-COFFEE'},
  {'name': 'Anesi Iced Choco', 'price': 100.00, 'category': 'NON-COFFEE'},
  {'name': 'Vanilla Milk', 'price': 90.00, 'category': 'ADDONS'},
  {'name': 'Vanilla Milk', 'price': 90.00, 'category': 'NON-COFFEE'},
  {'name': 'Vanilla Milk', 'price': 90.00, 'category': 'NON-COFFEE'},
  {'name': 'Vanilla Milk', 'price': 90.00, 'category': 'NON-COFFEE'},

  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(predefinedItems); 
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredItems = predefinedItems
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Menu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ProductRepository>(
                builder: (context, productRepo, child) {
                  final allItems = [
                    ...predefinedItems,
                    ...productRepo.addedProducts, // Merge predefined and new products
                  ];

                  return ListView(
                    children: [
                      _buildSection('COFFEE', allItems),
                      const SizedBox(height: 35),
                      _buildSection('NON-COFFEE', allItems),
                      const SizedBox(height: 35),
                      _buildSection('ADD-ONS', allItems),
                    ],
                  );
                },
              ),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return cartModel.items.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_cart),
                                const SizedBox(width: 8),
                                Text('${cartModel.items.length} Items'),
                              ],
                            ),
                            Text(
                                'Total: ${cartModel.totalPrice.toStringAsFixed(2)}'),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Carts(),
                                  ),
                                );
                              },
                              child: const Text('Go to Cart'),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String category, List<Map<String, dynamic>> items) {
    final categoryItems =
        items.where((item) => item['category'] == category).toList();

    if (categoryItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 0.8,
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CoffeeCard(item['name'], item['price']);
          },
        ),
      ],
    );
  }
}
