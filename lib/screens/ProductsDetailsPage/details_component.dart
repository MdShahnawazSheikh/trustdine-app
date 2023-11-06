import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';

class DetailsCard extends StatelessWidget {
  final String name, category, size, image, description, type;
  final double price;
  const DetailsCard({
    Key? key,
    required this.name,
    required this.category,
    required this.price,
    required this.size,
    required this.image,
    required this.description,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 170,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.grey.shade800),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF868686),
                ),
                child: Row(
                  children: [
                    Text(size),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: Color(0xFF868686),
                      ),
                    ),
                    Text("Category: $category")
                  ],
                ),
              ),
            ),
            /*  Row(
              children: [
                const Text("4.3"),
                const SizedBox(width: 8),
                SvgPicture.asset("assets/icons/rating.svg"),
                const SizedBox(width: 4),
                const Text("200+ Ratings")
              ],
            ), */
            // const Spacer(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InfoCard(
                  svgSrc: "assets/icons/rupee.svg",
                  title: price.toStringAsFixed(2),
                  subtitle: "Before Taxes",
                ),
                const SizedBox(width: 16),
                // const InfoCard(
                //   svgSrc: "assets/icons/clock.svg",
                //   title: "25",
                //   subtitle: "Minutes",
                // ),
                // const SizedBox(width: 24),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    final productToAdd =
                        AddedProduct(name, price, 1, image, size, type);
                    // Add the product to the cart using CartManager
                    CartManager().addProduct(productToAdd);
                    // String productName = widget.productName;
                    // String imagePath = widget.imagePath;
                    Fluttertoast.showToast(msg: "$name added to cart.");
                    print(CartManager().addedProducts.length);
                  },
                  style: OutlinedButton.styleFrom(
                    primary: const Color(0xFF22A45D),
                    fixedSize: const Size(120, 40),
                    side: const BorderSide(color: Color(0xFF22A45D)),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    "Add to Cart".toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Description",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.grey.shade800),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description.length > 0
                  ? description
                  : "No Description for this product",
              style:
                  Theme.of(context).textTheme.caption?.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.svgSrc,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String svgSrc, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          svgSrc,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }
}
