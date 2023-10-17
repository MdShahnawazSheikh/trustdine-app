import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RazorpayPaymentScreen extends StatefulWidget {
  final double paymentAmount;

  const RazorpayPaymentScreen({
    Key? key,
    required this.paymentAmount,
  }) : super(key: key);

  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late String paymentLink = '';

  @override
  void initState() {
    super.initState();
    _generateRazorpayPaymentLink();
  }

  Future<void> _generateRazorpayPaymentLink() async {
    String apiKey =
        'rzp_test_Z82cRZXwhEsVnK'; // Replace with your Razorpay API key
    String apiUrl =
        'https://api.razorpay.com/v1/invoices'; // Razorpay API endpoint

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    Map<String, dynamic> requestBody = {
      'type': 'link',
      'view_less': 1,
      'currency': 'INR',
      'amount': (widget.paymentAmount * 100).toInt(), // Amount in paisa
      'receipt': 'receipt_${DateTime.now().millisecondsSinceEpoch.toString()}',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          paymentLink = jsonResponse[
              'short_url']; // Get the payment link from the response
        });
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
        // Handle error scenario
      }
    } catch (e) {
      print('Error: $e');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay Payment Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (paymentLink.isNotEmpty)
              Image.network(paymentLink) // Display the payment link as an image
            else
              CircularProgressIndicator(),
            SizedBox(height: 20),
            if (paymentLink.isNotEmpty)
              Text(
                'Scan the QR code to make the payment\n${paymentLink}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
