import 'package:capstone_anesi/model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddProductScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String selectedSubCategory = 'COFFEE';

  void _saveProduct() {
  final String name = nameController.text;
  final double? price = double.tryParse(priceController.text);

  if (name.isNotEmpty && price != null) {
    Provider.of<ProductRepository>(context, listen: false).addProduct({
      'name': name,
      'price': price,
      'category': selectedSubCategory,
    });

    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter valid details')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADD PRODUCT/DRINKS',
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
                setState(() {
                  selectedSubCategory = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
            child: ElevatedButton(
              onPressed: _saveProduct,
                 style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
              child: const Text(
                'Add New Product',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}