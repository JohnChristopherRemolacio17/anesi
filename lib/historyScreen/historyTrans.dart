import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class HistoryTransactionScreen extends StatelessWidget {
  const HistoryTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('History Transaction'),
      ),
      body:const Center(
        child: Text(
          'This is the History Transaction screen.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
