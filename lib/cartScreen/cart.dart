import 'package:capstone_anesi/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/productModel.dart';
import 'cartmodel.dart';
import '../reportScreen/report.dart';
import '../utils/utils.dart'; // Adjust the path based on your folder structure

class Carts extends StatelessWidget {
  const Carts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<CartModel>(
        builder: (context, cartModel, child) {
          double totalPrice = cartModel.totalPrice;

          return cartModel.items.isEmpty
              ? const Center(
                  child: Text('Your cart is empty'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Cart Items Display
                    ...cartModel.items.map((item) {
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: kprimaryColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${item['price'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Provider.of<CartModel>(context,
                                                  listen: false)
                                              .removeItem(item);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    const Divider(),
                    // Order Summary Section
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...cartModel.items.map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['name']),
                              Text('${item['price'].toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalPrice.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Proceed to Payment Button
                    ElevatedButton(
                      onPressed: totalPrice > 0
                          ? () {
                              // Navigate to Payment Screen
                              Navigator.pushNamed(context, '/payment')
                                  .then((_) {
                                // After payment is completed, update sales data
                                for (var item in cartModel.items) {
                                  processPurchase(Product(
                                    name: item['name'],
                                    price: item['price'],
                                 // Wrap in a list

                                  ));
                                }
                                // Clear cart after payment
                                cartModel.clearCart();
                              });
                            }
                          : null, // Disable button if total price is zero
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Proceed to Payment"),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
