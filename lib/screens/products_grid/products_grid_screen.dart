import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trustdine/components/NetworkProductCardTwoRow.dart';

class ProductsGridPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String category;

  ProductsGridPage({required this.products, required this.category});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.grey.shade700,
          backgroundColor: Colors.white,
          title: Text(
            category,
          ),
        ),
        body: products.length > 0
            ? GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: screenHeight > screenWidth
                      ? (screenHeight / 3)
                      : screenHeight / 1.5,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return NetworkProductCardTwoRow(
                      image: products[index]['image'],
                      name: products[index]['name'],
                      category: products[index]['category'],
                      size: products[index]['size'],
                      price: products[index]['price'],
                      rating: products[index]['rating'],
                      type: products[index]['type'],
                      onPress: () {});
                },
              )
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 34.5,
                            /* top: screenHeight > screenWidth
                                  ? (screenHeight / 4.5)
                                  : screenHeight / 1.5 */
                          ),
                          child: SvgPicture.asset(
                            "assets/illustrations/empty_products.svg",
                            height: screenHeight > screenWidth
                                ? (screenHeight / 3)
                                : screenWidth / 3,
                          ),
                        ),
                        Text(
                          "No products found for $category",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ]),
                ),
              ));
  }
}
