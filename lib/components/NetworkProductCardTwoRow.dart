import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/screens/ProductsDetailsPage/product_details_page.dart';

// Todo: if product is veg show green or show red

class NetworkProductCardTwoRow extends StatelessWidget {
  final String image, name, category, size, rating, type, description;
  final double price;
  final VoidCallback onPress;
  const NetworkProductCardTwoRow(
      {super.key,
      required this.image,
      required this.name,
      required this.category,
      required this.size,
      required this.price,
      required this.rating,
      required this.onPress,
      required this.type,
      required this.description});

  @override
  Widget build(BuildContext context) {
    String pathOfType = "assets/illustrations/Veg_symbol.png";
    if (this.type == 'veg' || this.type == "Veg" || this.type == "VEG") {
      pathOfType = "assets/illustrations/Veg_symbol.png";
    } else if (this.type == 'non-veg' ||
        this.type == "Non-Veg" ||
        this.type == "NON-VEG" ||
        this.type == "Non-veg") {
      pathOfType = "assets/illustrations/Non_veg_symbol.png";
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
      cardHeight = screenWidth / 2.5;
    }
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(
                image: image,
                name: name,
                category: category,
                price: price,
                size: size,
                description: description,
              ),
            ));
      },
      onTap: () {
        final productToAdd = AddedProduct(name, price, 1, image, size);
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
              child: CachedNetworkImage(
                width: double.infinity,
                // Use CachedNetworkImage widget instead of Image.asset
                imageUrl: image, // Provide the internet image URL here
                fit: BoxFit.cover,
                height: cardHeight / 1.6,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Loading Content",
                    backgroundColor: Colors.grey,
                    color: Colors.black,
                    semanticsValue: AutofillHints.countryName,
                  ),
                ), // Loading indicator while the image is being fetched
                errorWidget: (context, url, error) => const Icon(
                    Icons.error), // Error widget if the image fails to load
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
                        height: cardHeight / 12,
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: defaultPadding / 2,
                        //   vertical: defaultPadding / 8,
                        // ),
                        child: Image.asset(
                          pathOfType,
                          fit: BoxFit.fill,
                        ),
                        /* decoration: BoxDecoration(
                            color: typeColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text(
                          "",
                          style: TextStyle(color: Colors.white),
                        ), */
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
                        child: Text("₹ $price"),
                      ),
                      Text(
                        size,
                        overflow: TextOverflow.ellipsis,
                      ),
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
