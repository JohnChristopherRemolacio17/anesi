import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/productModel.dart'; // Import the Product class

Future<void> processPurchase(Product purchasedItem) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedData = prefs.getString('dailySales');
  Map<int, double> dailySales = savedData != null
      ? Map<int, double>.from(jsonDecode(savedData))
      : {};

  int dayIndex = DateTime.now().weekday - 1; // Get current day index (0 = Monday)

  // Update the sales for the current day
  dailySales[dayIndex] = (dailySales[dayIndex] ?? 0) + purchasedItem.price;

  // Save updated sales data
  prefs.setString('dailySales', jsonEncode(dailySales));
}
