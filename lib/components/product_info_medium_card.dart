import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/constants.dart';

class ProductInfoMediumCard extends StatelessWidget {
  const ProductInfoMediumCard({
    super.key,
    required this.productName,
    required this.image,
    required this.size,
    required this.price,
    required this.rating,
    required this.press,
    required this.category,
  });
  final String rating, productName, image, size, category;
  final double price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        final productToAdd = AddedProduct(productName, price, 1, image, size);
        // Add the product to the cart using CartManager
        CartManager().addProduct(productToAdd);
        // String productName = widget.productName;
        // String imagePath = widget.imagePath;

        Fluttertoast.showToast(
          msg: "$productName added to cart.",
        );
        print(CartManager().addedProducts.length);
      },
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.25,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Text(
              productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              'Category: $category',
              maxLines: 1,
              style: const TextStyle(color: kBodyTextColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black, fontSize: 12),
                child: Row(
                  children: [
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
                    const Spacer(flex: 1),
                    Text('₹ $price'),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 2,
                      backgroundColor: Color(0xFF868686),
                    ),
                    const Spacer(),
                    Text(size),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
