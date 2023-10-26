import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';

class ProductTileCard extends StatelessWidget {
  const ProductTileCard({
    super.key,
    required this.imgSize,
    required this.image,
    required this.title,
    required this.price,
    required this.screenWidth,
    required this.size,
    required this.builderObject,
  });

  final double imgSize, price, screenWidth;
  final String image, title, size;
  final List<Map<String, dynamic>> builderObject;

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
          child: CachedNetworkImage(
            width: imgSize,
            height: imgSize,
            // Use CachedNetworkImage widget instead of Image.asset
            imageUrl: image, // Provide the internet image URL here
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
                child:
                    CircularProgressIndicator()), // Loading indicator while the image is being fetched
            errorWidget: (context, url, error) => const Icon(
                Icons.error), // Error widget if the image fails to load
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
              "Price: ₹ $price\nSize: $size",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              final productToAdd = AddedProduct(title, price, 1, image, size);
              // Add the product to the cart using CartManager
              CartManager().addProduct(productToAdd);
              // String productName = widget.productName;
              // String imagePath = widget.imagePath;
              Fluttertoast.showToast(msg: "$title added to cart.");
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
    );
  }
}
