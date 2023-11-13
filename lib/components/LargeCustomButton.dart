import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LargeCustomButton extends StatelessWidget {
  final String yourText;
  final VoidCallback
      onPressedFunction; // Use VoidCallback for onPressed function
  final Color buttonColor;
  final Color textColor;
  const LargeCustomButton(
      {Key? key, // Use Key? for specifying the widget's key
      required this.yourText,
      required this.onPressedFunction,
      required this.buttonColor,
      required this.textColor})
      : super(key: key); // Set the key parameter using super

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 2;
    return Container(
      width: buttonWidth,
      child: RawMaterialButton(
        fillColor: buttonColor,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: onPressedFunction,
        child: Container(
          width: buttonWidth / 2.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  yourText,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                CupertinoIcons.arrow_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
