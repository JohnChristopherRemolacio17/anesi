import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Correct import for SharedPreferences
import '../model/productModel.dart'; // Import Product and menu list

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Declare the in-memory sales data
  Map<int, double> dailySales = {
    0: 0.0, // Monday
    1: 0.0, // Tuesday
    2: 0.0, // Wednesday
    3: 0.0, // Thursday
    4: 0.0, // Friday
    5: 0.0, // Saturday
    6: 0.0, // Sunday
  };

  List<bool> isSelected = [true, false, false]; // Default to Daily view

  @override
  void initState() {
    super.initState();
    loadSales(); // Load saved sales data when the app starts
  }

  // Save dailySales to SharedPreferences
  Future<void> saveSales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dailySales', jsonEncode(dailySales));
  }

  // Load dailySales from SharedPreferences
  Future<void> loadSales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? salesData = prefs.getString('dailySales');
    if (salesData != null) {
      setState(() {
        dailySales = Map<int, double>.from(jsonDecode(salesData));
      });
    }
  }

  // Process payment and update sales (manually)
  void processPayment(double amount) {
    int dayIndex = DateTime.now().weekday - 1; // Get current day index (0 = Monday)
    setState(() {
      dailySales[dayIndex] = dailySales[dayIndex]! + amount; // Update the sales amount
    });
    saveSales(); // Save updated sales data
  }

  // Process purchase based on product
  void processPurchase(Product purchasedItem) {
    int dayIndex = DateTime.now().weekday - 1; // Get current day index (0 = Monday)

    // Update the sales for the current day
    setState(() {
      dailySales[dayIndex] = dailySales[dayIndex]! + purchasedItem.price;
    });

    // Save updated sales data
    saveSales();
  }

  @override
  Widget build(BuildContext context) {
    double grossSales = dailySales.values.reduce((a, b) => a + b); // Calculate gross sales

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Column(
            children: [
              Text(
                'REPORT',
                style: TextStyle(
                  color: Color(0xFF004D40), // Dark green color for the REPORT sign
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Color(0xFF777777),
                thickness: 1,
                endIndent: 10,
                indent: 10,
                height: 5,
              ), // Low-opacity underline
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1), // Low-opacity box for overall content
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle Buttons for Daily, Weekly, Monthly
                Center(
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.black,
                    fillColor: Colors.transparent,
                    color: Colors.black,
                    borderColor: const Color(0xFF003366), // Dark blue for borders
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildIconWithText('Daily', Icons.calendar_today_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildIconWithText('Weekly', Icons.calendar_today_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildIconWithText('Monthly', Icons.calendar_today_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Container for "Daily Sales"
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20), // Margin to separate sections
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1), // Low-opacity box
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Sales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003366), // Dark blue
                        ),
                      ),
                      const SizedBox(height: 20),

                      AspectRatio(
                        aspectRatio: 1.70,
                        child: LineChart(_generateDynamicLineChartData()), // Using the new function
                      ),
                      const SizedBox(height: 20),

                      // Gross Sales Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gross sales',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)), // Low-visibility text
                                ),
                                Text(
                                  grossSales.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)), // Bold, dark blue
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // List of Daily Sales
                Column(
                  children: dailySales.entries.map((entry) {
                    return ListTile(
                      title: Text("Day ${entry.key + 1} Sales"),
                      trailing: Text(entry.value.toStringAsFixed(2)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _generateDynamicLineChartData() {
    // New dynamic data function
    List<FlSpot> spots = [];

    // Generate FlSpot data points from dailySales
    dailySales.forEach((day, sales) {
      spots.add(FlSpot(day.toDouble(), sales));
    });

    if (spots.isEmpty) {
      spots.add(FlSpot(0, 0)); // Placeholder data if empty
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.green, // Fixed to use 'color' instead of 'colors'
          barWidth: 2,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.green.withOpacity(0.3), Colors.green.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              if (value.toInt() >= 0 && value.toInt() < weekdays.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    weekdays[value.toInt()],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
          left: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
        ),
      ),
    );
  }

  Widget _buildIconWithText(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF003366)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
        ),
      ],
    );
  }
}
