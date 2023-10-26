import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/screens/ProductsDetailsPage/product_details_page.dart';

class NetworkProductInfoMediumCard extends StatelessWidget {
  const NetworkProductInfoMediumCard({
    super.key,
    required this.productName,
    required this.image,
    required this.size,
    required this.price,
    required this.rating,
    required this.press,
    required this.category,
    required this.type,
    required this.description,
  });
  final String rating, productName, image, size, category, type, description;
  final double price;
  final VoidCallback press;

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
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onLongPress: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
                image: image,
                name: productName,
                category: category,
                price: price,
                size: size,
                description: description),
          )),
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
                child: CachedNetworkImage(
                  // Use CachedNetworkImage widget instead of Image.asset
                  imageUrl: image, // Provide the internet image URL here
                  fit: BoxFit.cover,
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
                        child: Image.asset(
                      pathOfType,
                      height: 20,
                    )),
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
