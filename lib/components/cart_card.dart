import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cartCard extends StatelessWidget {
  const cartCard({
    super.key,
    required this.imgSize,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.screenWidth,
    required this.size,
    required this.decreaseButton,
    required this.deleteButton,
  });

  final double imgSize, price, screenWidth;
  final String image, title, size;
  final int quantity;
  final VoidCallback decreaseButton, deleteButton;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 10,
      focusColor: Colors.grey,
      tileColor: Colors.grey.shade200,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            width: imgSize,
            height: imgSize,
          ),
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth / 3.6,
            child: Text(
              "Quantity: $quantity\nPrice: ₹ $price\nSize: $size",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: decreaseButton,
                  icon: const Icon(
                    CupertinoIcons.cart_badge_minus,
                    color: Colors.cyan,
                  )),
              IconButton(
                  onPressed: deleteButton,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  )),
            ],
          )
        ],
      ),
      isThreeLine: true,
    );
  }
}
