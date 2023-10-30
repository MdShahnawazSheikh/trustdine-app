import 'package:flutter/material.dart';
import 'package:trustdine/backend/qr_logic.dart';
import 'package:trustdine/components/home_button.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:trustdine/main.dart';

class CashPayment extends StatefulWidget {
  final String orderId;
  final double logoWidth;

  const CashPayment({
    required this.orderId,
    Key? key,
    required this.logoWidth,
  }) : super(key: key);

  @override
  _CashPaymentState createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  late Timer _timer;
  int _secondsRemaining = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          // Redirect to MyApp() when the timer reaches 0
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
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
            Lottie.asset(
              "assets/illustrations/circle_tick2.json",
              repeat: false,
              height: screenHeight / 4,
            ),
            /* const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ), */
            // const SizedBox(height: 16),
            const Text(
              'Pay in Cash',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GenerateQr(data: widget.orderId.toString()),
            Text(
              'Order ID: ${widget.orderId}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Redirecting in $_secondsRemaining seconds...',
              style: const TextStyle(fontSize: 16),
            ),
            GoHomeButton(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
