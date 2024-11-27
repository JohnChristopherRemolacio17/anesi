import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function(Map<String, dynamic>, int) onSave;
  final Function(int) onDelete;

  EditProductScreen({
    Key? key,
    required this.product,
    required this.index,
    required this.onSave,
    required this.onDelete,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String selectedSubCategory = 'COFFEE';

  @override
  Widget build(BuildContext context) {
    // Pre-fill the controllers
    nameController.text = product['name'];
    priceController.text = product['price'].toString();
    selectedSubCategory = product['category'] ?? 'COFFEE';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EDIT PRODUCT/DRINKS',
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
            const Text(
              'Details Product',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Name Product',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter product name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Selling Price',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter product price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Sub Category',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              items: ['COFFEE', 'NON-COFFEE']
                  .map((subCategory) => DropdownMenuItem(
                        value: subCategory,
                        child: Text(subCategory),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedSubCategory = value!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
            child:ElevatedButton(              
              onPressed: () {
                // Save changes
                final updatedProduct = {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                  'category': selectedSubCategory,
                };
                print('Updated Product Sent to onSave: $updatedProduct'); // Debug Log
                onSave(updatedProduct, index);
                Navigator.pop(context);
              },
               style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ),
            const SizedBox(height: 16.0), 
          ],
        ),
      ),
    );
  }

}
