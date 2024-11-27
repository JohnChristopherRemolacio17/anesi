// lib/listScreen/listScreen.dart

import 'package:capstone_anesi/model/salesData.dart';  // Correct import path

// lib/model/sales_data.dart

class SalesData {
  double cashSales;
  double gcashSales;
  double totalSales;
  Map<String, int> productSales;

  SalesData({
    this.cashSales = 0,
    this.gcashSales = 0,
    this.totalSales = 0,
    this.productSales = const {},
  });

  void addCashSale(double amount) {
    cashSales += amount;
    totalSales += amount;
  }

  void addGCashSale(double amount) {
    gcashSales += amount;
    totalSales += amount;
  }

  void addProductSale(String productName) {
    productSales.update(productName, (value) => value + 1, ifAbsent: () => 1);
  }
}
