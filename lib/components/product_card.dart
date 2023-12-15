import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/cartManager.dart';

class ProductWidget extends StatefulWidget {
  final int index;

  const ProductWidget({Key? key, required this.index}) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textThemeRef = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerWidth = constraints.maxWidth * 0.9;
          double containerHeight = containerWidth * 1.18;
          double spacer = containerHeight * 0.13;

          return Container(
            width: containerWidth,
            height: containerHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: containerWidth / 18,
                  vertical: containerHeight / 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: containerWidth,
                    height: containerHeight * 0.74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(205, 253, 251, 1),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          selectedCategory[widget.index]['image'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: spacer,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCategory[widget.index]['name'],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: textThemeRef.titleMedium!.copyWith(
                            color: const Color.fromRGBO(37, 43, 66, 1),
                            fontFamily: 'Montserrat_Bold',
                          ),
                        ),
                        SizedBox(
                          height: spacer / 5,
                        ),
                        Text(
                          "₹ ${selectedCategory[widget.index]['price']}",
                          textAlign: TextAlign.center,
                          style: textThemeRef.titleSmall!.copyWith(
                            color: const Color.fromRGBO(114, 114, 114, 1),
                            fontFamily: 'Montserrat_Medium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: spacer / 5,
                        ),
                        Text(
                          "${selectedCategory[widget.index]['size']}"
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: textThemeRef.titleSmall!.copyWith(
                            color: const Color.fromRGBO(114, 114, 114, 1),
                            fontFamily: 'Montserrat_Medium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: spacer / 2,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: const Color(0xFF22A45D),
                            // fixedSize: const Size(120, 40),
                            side: const BorderSide(color: Color(0xFF22A45D)),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          child: const Text(
                            "ADD",
                            // style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            final productToAdd = AddedProduct(
                              selectedCategory[widget.index]['name'],
                              selectedCategory[widget.index]['price'],
                              1,
                              selectedCategory[widget.index]['image'],
                              selectedCategory[widget.index]['size'],
                              selectedCategory[widget.index]['type'],
                            );
                            // Add the product to the cart using CartManager
                            CartManager().addProduct(productToAdd);
                            // String productName = widget.productName;
                            // String imagePath = widget.imagePath;
                            CoolAlert.show(
                              width: screenWidth / 2,
                              title: "Added to Cart",
                              context: context,
                              backgroundColor: const Color(0xFF22A45D),
                              type: CoolAlertType.success,
                              text:
                                  "1 ${selectedCategory[widget.index]['name']} added to cart",
                              lottieAsset:
                                  "assets/illustrations/food_loading.json",
                              confirmBtnColor: const Color(0xFF22A45D),
                            );
                            /*  Fluttertoast.showToast(
                          msg:
                              "${selectedCategory[widget.index]['name']} added to cart.",
                        ); */
                            print(CartManager().addedProducts.length);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
