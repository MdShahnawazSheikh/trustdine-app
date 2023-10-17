import 'package:flutter/material.dart';
import 'package:trustdine/components/ProductCardTwoRow.dart';
import 'package:trustdine/apiData.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
      cardHeight = screenWidth / 2.5;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          "Featured Products",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: featuredProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: screenHeight > screenWidth ? 250 : cardHeight,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductCardTwoRow(
                  onPress: () {},
                  image: featuredProducts[index]['image'],
                  name: featuredProducts[index]['name'],
                  category: featuredProducts[index]['category'],
                  size: featuredProducts[index]['size'],
                  price: featuredProducts[index]['price'],
                  rating: featuredProducts[index]['rating']);
            },
          ),
        ),
      ),
    );
  }
}
