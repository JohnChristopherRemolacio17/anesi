import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cartScreen/cartmodel.dart';
import '../model/salesData.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cashInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cashInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Page"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Cash"),
            Tab(text: "Non-Cash"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCashPaymentTab(),
          _buildNonCashPaymentTab(),
        ],
      ),
    );
  }

  Widget _buildCashPaymentTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Text(
                'Total Bill: ₱${cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _cashInputController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(12, (index) {
                if (index == 9) {
                  // Backspace Button
                  return ElevatedButton(
                    onPressed: () {
                      if (_cashInputController.text.isNotEmpty) {
                        setState(() {
                          _cashInputController.text = _cashInputController.text
                              .substring(0, _cashInputController.text.length - 1);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.backspace, color: Colors.black),
                  );
                } else if (index == 11) {
                  // Enter Button
                  return ElevatedButton(
                    onPressed: () {
                      _processPayment(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "ENTER",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  // Number Buttons
                  String buttonText = index == 10 ? '0' : '${(index + 1) % 10}';
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cashInputController.text += buttonText;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonCashPaymentTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Text(
                'Total Bill: ₱${cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Scan QR Code to Pay",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/qr-code.png',
              height: 200,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add non-cash payment logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Complete Payment",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    double enteredAmount = double.tryParse(_cashInputController.text) ?? 0.0;
    double totalBill = cartModel.totalPrice;

    if (enteredAmount >= totalBill && totalBill > 0) {
      // Handle successful payment logic
      cartModel.clearCart();
      _cashInputController.clear();
      _showDialog(context, "Payment Successful!", "Thank you for your payment.");
    } else {
      // Show error dialog
      _showDialog(context, "Payment Failed!", "Insufficient funds.");
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
