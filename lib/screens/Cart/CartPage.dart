import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/backend/checkout.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/cart_card_network.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/main.dart';

class CartPage extends StatefulWidget {
  final double logoWidth;
  const CartPage({super.key, required this.logoWidth});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imgSize =
        screenHeight > screenWidth ? (screenWidth / 4) : (screenHeight / 4);
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            logoWidth: widget.logoWidth,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: "Your Cart",
                  buttonText: "Checkout",
                  press: () {
                    if (CartManager().addedProducts.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ));
                      double finalPrice = double.parse(CartManager()
                          .calculateTotalPrice()
                          .toStringAsFixed(2));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckOutPage(
                              paymentAmount: finalPrice,
                              logoWidth: widget.logoWidth,
                            ),
                          ));
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please add items to cart to proceed!",
                        timeInSecForIosWeb: 4,
                      );
                    }
                  },
                ),
                Text(
                  "Grand Total: ₹ ${CartManager().calculateTotalPrice().toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
          ),
          CartManager().addedProducts.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: defaultPadding,
                            left: defaultPadding,
                            bottom: 6.0),
                        child: NetworkCartCard(
                          imgSize: imgSize,
                          image: CartManager().addedProducts[index].imagePath,
                          title: CartManager().addedProducts[index].productName,
                          price: CartManager().addedProducts[index].price,
                          quantity: CartManager().addedProducts[index].quantity,
                          size: CartManager().addedProducts[index].size,
                          screenWidth: screenWidth,
                          decreaseButton: () {
                            _deductItem(index, setState);
                          },
                          deleteButton: () {
                            // Pass setState to trigger a rebuild
                            _removeProduct(index, setState);
                          },
                        ),
                      );
                    },
                    childCount: CartManager().addedProducts.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        SvgPicture.asset(
                          'assets/illustrations/empty.svg',
                          height: screenHeight > screenWidth
                              ? (screenHeight / 3)
                              : screenWidth / 3,
                        ),
                        Text(
                          "Your cart is empty...\nTry adding some delicious foods!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenHeight / 40),
          topRight: Radius.circular(screenHeight / 40),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            right: screenWidth / 30,
            left: screenWidth / 30,
            top: 10,
          ),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: const Color(0xFF22A45D),
              // fixedSize: const Size(120, 40),
              side: const BorderSide(color: Color(0xFF22A45D)),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: const Text(
              "CHECKOUT",
              // style: const TextStyle(fontSize: 12),
            ),
            onPressed: () {
              if (CartManager().addedProducts.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ));
                double finalPrice = double.parse(
                    CartManager().calculateTotalPrice().toStringAsFixed(2));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckOutPage(
                        paymentAmount: finalPrice,
                        logoWidth: widget.logoWidth,
                      ),
                    ));
              } else {
                Fluttertoast.showToast(
                  msg: "Please add items to cart to proceed!",
                  timeInSecForIosWeb: 4,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Function to remove a product from the cart
  void _deductItem(int index, StateSetter setState) {
    CartManager().deductQuantity(index); // Deduct quantity if possible
    setState(() {}); // Trigger a rebuild of the StatefulBuilder content
  }

  // Function to remove a product from the cart
  void _removeProduct(int index, StateSetter setState) {
    CartManager().removeProduct(index);
    setState(() {}); // Trigger a rebuild of the StatefulBuilder content
  }
}
