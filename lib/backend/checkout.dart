import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/screens/PaymentSuccessfull/cashPage.dart';
import 'package:trustdine/backend/paymentSuccessPage.dart';
import 'package:trustdine/printer/printer_utils.dart';
import 'package:trustdine/screens/StaticQr/static_qr.dart';

class CheckOutPage extends StatefulWidget {
  final double paymentAmount, logoWidth;
  const CheckOutPage({
    required this.paymentAmount,
    super.key,
    required this.logoWidth,
  });

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Razorpay? _razorpay;

  void _handleSuccessfullPayment(PaymentSuccessResponse response) {
    final paymentId = response.paymentId.toString();

    Fluttertoast.showToast(
      msg: "Payment Successfull\nPayment ID: ${response.paymentId}",
      timeInSecForIosWeb: 4,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(
          orderId: (paymentId),
          logoWidth: widget.logoWidth,
        ),
      ),
    );
    CartManager().pushCartToFirestore(paymentId, "razorpay");
    printReceipt(paymentId);
    Timer(const Duration(seconds: 5), () {
      CartManager().clearCart();
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

  // Cash Payment

  Future _handleCashPayment(String cashOrderID) async {
    final orderID = cashOrderID;
    Fluttertoast.showToast(
      msg: "Order Confirmed!\nOrder ID: $orderID",
      timeInSecForIosWeb: 4,
    );
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CashPayment(
            orderId: orderID,
            logoWidth: widget.logoWidth,
          ),
        ));

    CartManager().pushCartToFirestore(orderID, "Cash");

    printReceipt(orderID);
    await Future.delayed(const Duration(seconds: 3), () {
      CartManager().clearCart();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Error: ${response.code} - ${response.message}",
      timeInSecForIosWeb: 4,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "Error with wallet: ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccessfullPayment);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void makePayment() async {
    var options = {
      'key': 'rzp_test_Z82cRZXwhEsVnK',
      'amount': widget.paymentAmount * 100,
      'name': 'TrustSign India',
      'description': "Paying for Food Order at TrustSign's kiosk",
      'prefill': {'contact': "PhoneNumber", 'email': "Email Address"},
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: Text(e.toString()),
          actions: [
            ElevatedButton(onPressed: () {}, child: const Text("Close"))
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double discountPercentage =
        double.parse(InvoiceData[0]['discount'].toString());
    double discountAmount = (discountPercentage / 100) * widget.paymentAmount;
    double amountAfterDiscount = widget.paymentAmount - discountAmount;
    double gstPercentage = double.parse(InvoiceData[0]['gst'].toString());
    double gstAmount = (gstPercentage / 100) * amountAfterDiscount;
    double finalAmount = amountAfterDiscount + gstAmount;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          "assets/trustdine_logo.png",
          width: widget.logoWidth,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  "https://lottie.host/9a864854-307d-4e40-a645-5ebd7b0159ed/caWKmUVLEm.json",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Thank You for your order\nChoose a payment method",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                DataTable(
                  dataTextStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black87),
                  headingTextStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontFamily: "Montserrat_Bold"),
                  columns: const [
                    DataColumn(label: Text('Price Breakdown')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('   Net Total')),
                      DataCell(Text('₹ ${widget.paymentAmount}')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(' - Discount @$discountPercentage%')),
                      DataCell(Text('₹ $discountAmount')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(' + GST @$gstPercentage%')),
                      DataCell(Text('₹ $gstAmount')),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text(
                        'Billing Amount',
                        style: TextStyle(color: Colors.blue),
                      )),
                      DataCell(Text(
                        '₹ ${amountAfterDiscount + gstAmount}',
                        style: const TextStyle(color: Colors.blue),
                      )),
                    ]),
                  ],
                  showBottomBorder: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  child: const CheckoutButton(
                    yourText: "Pay with QR",
                    yourIcon: FontAwesomeIcons.qrcode,
                    buttonColor: Color.fromARGB(255, 136, 0, 255),
                    textColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onTap: () {
                    String orderId = generateHexCode();
                    print("tapped");
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpiPaymentScreenStatic(
                          amount: finalAmount,
                          receiverUpiId: userDetails['upiId'],
                          logoWidth: widget.logoWidth,
                          orderId: orderId,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  child: const CheckoutButton(
                      yourText: "Pay with Cash",
                      yourIcon: FontAwesomeIcons.moneyCheckDollar,
                      buttonColor: Colors.green,
                      textColor: Color.fromARGB(255, 255, 255, 255)),
                  onTap: () {
                    _handleCashPayment(generateHexCode());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Powered by TrustSign",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 25,
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Go Back",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String generateHexCode() {
  // Generate a random 6-digit hexadecimal number
  String randomHex =
      (1000000 + (DateTime.now().millisecondsSinceEpoch % 9000000))
          .toRadixString(16);

  // Ensure the hexadecimal number is exactly 6 digits
  randomHex = randomHex.padLeft(6, '0');

  // Create the pattern by repeating the 6-digit number twice
  String hexCode = randomHex + randomHex;

  return hexCode;
}

class CheckoutButton extends StatelessWidget {
  final String yourText;
  final IconData yourIcon;
  final Color textColor;
  final Color buttonColor;
  const CheckoutButton({
    required this.yourIcon,
    required this.yourText,
    required this.textColor,
    required this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      // height: 50,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: buttonColor),
      // height: screenHeight / 15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            yourText,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            width: 6,
          ),
          FaIcon(
            yourIcon,
            size: 30,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
