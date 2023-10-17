import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trustdine/backend/qr_logic.dart';
import 'package:trustdine/main.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String orderId; // Add any other order details we want to display
  final double logoWidth;

  const PaymentSuccessPage(
      {required this.orderId, Key? key, required this.logoWidth})
      : super(key: key);

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Start a timer to redirect the user after 10 seconds
    Timer(Duration(seconds: 10), () {
      // Replace the current route with the HomeScreen route
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        // floating: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Image.asset(
            'assets/trustdine_logo.png',
            width: widget.logoWidth,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // const SizedBox(height: 16),
            GenerateQr(data: widget.orderId),
            Text(
              'Order ID: ${widget.orderId}',
              style: const TextStyle(fontSize: 18),
            ),
            // Text(
            //     "Product Name: ${CartManager().addedProducts[0].productName}") //test purpose
            // You can add more order details here if needed
          ],
        ),
      ),
    );
  }
}
