import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/cartManager.dart';

class CustomSeatchDelegate extends SearchDelegate {
  final double screenWidth;
  Iterable<String> searchTerms = productNames;

  CustomSeatchDelegate({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    required this.screenWidth,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var food in searchTerms) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(food);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        Map item = {};
        allProducts.forEach((element) {
          if (element['foodName'] == result) {
            item = element;
          }
        });
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: Colors.grey.shade100,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item['foodImg'],
                width: screenWidth / 8,
                height: screenWidth / 8,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
            title: Text("${item['foodName']}"),
            subtitle: Text("${item['foodSize']} - ${item['foodPrice']}"),
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: const Color(0xFF22A45D),
                // fixedSize: const Size(120, 40),
                side: const BorderSide(color: Color(0xFF22A45D)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: const Text(
                "ADD TO CART",
                // style: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                print("clicked");
                final productToAdd = AddedProduct(
                  item['foodName'],
                  double.parse(item['foodPrice']),
                  1,
                  item['foodImg'],
                  item['foodSize'],
                  item['foodType'],
                );
                CartManager().addProduct(productToAdd);
                CoolAlert.show(
                  width: screenWidth / 2,
                  title: "Added to Cart",
                  context: context,
                  backgroundColor: const Color(0xFF22A45D),
                  type: CoolAlertType.success,
                  text: "1 ${item['foodName']} added to cart",
                  lottieAsset: "assets/illustrations/food_loading.json",
                  confirmBtnColor: const Color(0xFF22A45D),
                );
                print(CartManager().addedProducts.length);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var food in searchTerms) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(food);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        Map item = {};
        allProducts.forEach((element) {
          if (element['foodName'] == result) {
            item = element;
          }
        });
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: Colors.grey.shade100,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item['foodImg'],
                width: screenWidth / 8,
                height: screenWidth / 8,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
            title: Text("${item['foodName']}"),
            subtitle: Text("${item['foodSize']} - ${item['foodPrice']}"),
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: const Color(0xFF22A45D),
                // fixedSize: const Size(120, 40),
                side: const BorderSide(color: Color(0xFF22A45D)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: const Text(
                "ADD TO CART",
                // style: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                print("clicked");
                final productToAdd = AddedProduct(
                  item['foodName'],
                  double.parse(item['foodPrice']),
                  1,
                  item['foodImg'],
                  item['foodSize'],
                  item['foodType'],
                );
                CartManager().addProduct(productToAdd);
                CoolAlert.show(
                  width: screenWidth / 2,
                  title: "Added to Cart",
                  context: context,
                  backgroundColor: const Color(0xFF22A45D),
                  type: CoolAlertType.success,
                  text: "1 ${item['foodName']} added to cart",
                  lottieAsset: "assets/illustrations/food_loading.json",
                  confirmBtnColor: const Color(0xFF22A45D),
                );
                print(CartManager().addedProducts.length);
              },
            ),
          ),
        );
      },
    );
  }
}
