import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/backend/qr_logic.dart';
import 'package:trustdine/screens/PaymentSuccessfull/static_qr_pay_success_page.dart';
import 'package:trustdine/main.dart';
import 'package:trustdine/printer/printer_utils.dart';

class UpiPaymentScreenStatic extends StatefulWidget {
  final String receiverUpiId, orderId;
  final double amount, logoWidth;

  const UpiPaymentScreenStatic({
    required this.receiverUpiId,
    required this.amount,
    Key? key,
    required this.logoWidth,
    required this.orderId,
  }) : super(key: key);

  @override
  _UpiPaymentScreenStaticState createState() => _UpiPaymentScreenStaticState();
}

class _UpiPaymentScreenStaticState extends State<UpiPaymentScreenStatic> {
  late Timer _timer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          // Redirect to MyApp() when the timer reaches 0
          _handleQRPayment();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StaticQRPayment(
                      orderId: widget.orderId,
                      logoWidth: widget.logoWidth,
                    )),
          );
        }
      });
    });
  }

  void printReceipt(String orderID) async {
    List<AddedProduct> cartItems = CartManager()
        .addedProducts; // Retrieve the cart items from your CartManager
    double totalAmount = CartManager()
        .calculateTotalPrice(); // Calculate total price from CartManager

    PrinterUtils()
        .printRestaurantReceipt("TrustDine", orderID, cartItems, totalAmount);
  }

  void _handleQRPayment() async {
    CartManager().pushCartToFirestore(widget.orderId, "static upi");
    printReceipt(widget.orderId);
    await Future.delayed(const Duration(seconds: 3), () {
      CartManager().clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    // UPI payment details
    String upiUrl =
        'upi://pay?pa=${widget.receiverUpiId}&pn=Recipient&mc=123456&tid=1234567890&cu=INR&am=${widget.amount}&url=https://trustdine.com';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'UPI Payment',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Scan the QR below to pay\nINR${widget.amount}",
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GenerateQr(data: upiUrl),
                const SizedBox(height: 20),
                Text(
                  'Supported by all UPI Apps',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),

                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.googlePay,
                      size: 45,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "assets/illustrations/phonepe.svg",
                      height: 80,
                      color: Colors.black,
                    ),
                    const SizedBox(
                        // width: 5,
                        ),
                    SvgPicture.asset(
                      "assets/illustrations/paytm.svg",
                      height: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
                Text(
                  'Redirecting in $_secondsRemaining seconds...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Incase of failure, mode of payment\nwill be automatically converted to cash.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    CartManager().clearCart();
                    isOrdering = false;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ));
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel Payment"),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
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
