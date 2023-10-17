import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PhonePePage extends StatefulWidget {
  const PhonePePage({super.key});

  @override
  State<PhonePePage> createState() => _PhonePePageState();
}

class _PhonePePageState extends State<PhonePePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment QR Code'),
      ),
      body: Center(
          // child: QrImage(
          //   data: 'QR_CODE_DATA', // Pass the QR code data here
          //   version: QrVersions.auto,
          //   size: 200.0,
          // ),
          ),
    );
    ;
  }
}
