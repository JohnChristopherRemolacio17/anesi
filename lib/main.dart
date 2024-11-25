import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/cartScreen/noodlesModel.dart';
import 'package:capstone_anesi/cartScreen/transactionModel.dart';
import 'package:capstone_anesi/hamburgerIcon/hamburger.dart';
import 'package:capstone_anesi/listsScreen/lists.dart';
import 'package:capstone_anesi/model/productModel.dart';

import 'package:capstone_anesi/productScreen/product.dart' as productScreen;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orderModel.dart'; // Import the OrderModel class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(
    MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (context) => ProductRepository()),
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => CartModelNoodles()),
        ChangeNotifierProvider(create: (context) => OrderModel()),
        ChangeNotifierProvider(create: (context) => TransactionModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cart',
      initialRoute: '/',
      routes: {
        '/product': (context) => const productScreen.Product(),
        '/cart': (context) => const Carts(),
        '/list': (context) => const ListScreen(),
        'mainscreen': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: const BottomNavBar(),
    );
  }
}
