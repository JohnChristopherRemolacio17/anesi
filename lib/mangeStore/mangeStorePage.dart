import 'package:capstone_anesi/mangeStore/category/setProductScreen.dart';
import 'package:flutter/material.dart';

class ManageStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MANAGE STORE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Set Product'),
           
          ),
          const Divider(),
          ListTile(
            title: const Text('Category/Product'),
            subtitle: const Text('3 Category, 25 Items'),
            trailing: const Icon(Icons.arrow_forward_ios),
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SetProductScreen()),
  );
},
          ),
          const Divider(),
          ListTile(
            title: const Text('Sub Category'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation or functionality here
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Cashier & Payment'),
            subtitle: const Text('Cash on Hand'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation or functionality here
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Set Printer'),
            subtitle: const Text('Printer'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation or functionality here
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('History Transaction'),
            subtitle: const Text('Expenses'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation or functionality here
            },
          ),
        ],
      ),
    );
  }
}
