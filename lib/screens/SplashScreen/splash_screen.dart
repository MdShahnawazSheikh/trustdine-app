import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*  ColorizeAnimatedTextKit(
              text: const ['trustdine'],
              textStyle: const TextStyle(
                fontSize: 50,
                fontFamily: 'impact',
                // fontWeight: FontWeight.bold,
              ),
              colors: const [
                Colors.black87,
                Colors.black54,
                Colors.black45,
                Colors.black38,
              ],
              textAlign: TextAlign.start,
            ), */
            const SizedBox(height: 20.0),
            const CircularProgressIndicator(), // You can add any additional loading indicator if needed
          ],
        ),
      ),
    );
  }
}
