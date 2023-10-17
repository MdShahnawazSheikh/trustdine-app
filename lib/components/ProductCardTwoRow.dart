import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/constants.dart';

class ProductCardTwoRow extends StatelessWidget {
  final String image, name, category, size, rating;
  final double price;
  final VoidCallback onPress;
  const ProductCardTwoRow(
      {super.key,
      required this.image,
      required this.name,
      required this.category,
      required this.size,
      required this.price,
      required this.rating,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
      cardHeight = screenWidth / 2.5;
    }
    return GestureDetector(
      onTap: () {
        final productToAdd =
            AddedProduct(name, price, 1, image, size);
        // Add the product to the cart using CartManager
        CartManager().addProduct(productToAdd);
        // String productName = widget.productName;
        // String imagePath = widget.imagePath;
        Fluttertoast.showToast(msg: "$name added to cart.");
        print(CartManager().addedProducts.length);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 0, 0, 0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: cardHeight / 1.6,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Title Text:
                      SizedBox(
                        width: cardHeight / 2.5,
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2,
                          vertical: defaultPadding / 8,
                        ),
                        decoration: BoxDecoration(
                            color: kActiveColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          rating,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(category,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: kBodyTextColor)),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenHeight > screenWidth
                            ? (cardHeight / 3)
                            : (cardHeight / 2),
                        child: Text(
                          size,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("₹ $price"),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
