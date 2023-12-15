import 'package:flutter/material.dart';
import 'cartManager.dart';

class AddRemoveButton extends StatefulWidget {
  final String imagePath;
  final String productName;
  final double price;
  final String productSize, type;
  const AddRemoveButton(
      {required this.imagePath,
      required this.productName,
      required this.price,
      required this.productSize,
      super.key,
      required this.type});
  @override
  _AddRemoveButtonState createState() => _AddRemoveButtonState();
}

class _AddRemoveButtonState extends State<AddRemoveButton> {
  int count = 1;
  bool isAdded = false;

  void _toggleButton() {
    setState(() {
      isAdded = !isAdded;
      // Remove the condition to allow count to reach zero
    });
  }

  void _decrementCount() {
    if (count > 0) {
      setState(() {
        count--;
        if (count == 0) {
          _toggleButton();
        }
      });
    }
  }

  void _incrementCount() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.rectangle),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isAdded
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementCount,
                    ),
                    Text(
                      '$count',
                      style: TextStyle(fontSize: screenwidth / 28),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementCount,
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    final productToAdd = AddedProduct(
                        widget.productName,
                        widget.price,
                        1,
                        widget.imagePath,
                        widget.productSize,
                        widget.type);
                    // Add the product to the cart using CartManager
                    CartManager().addProduct(productToAdd);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.01),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Text(
                      'ADD',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: screenwidth / 28),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
