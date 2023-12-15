import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/backend/checkout.dart';
import 'package:trustdine/components/cart_card_network.dart';
import 'package:trustdine/components/sidebar_card.dart';
import 'package:trustdine/main.dart';
import 'package:trustdine/printer/printer_dialog.dart';

class QuickAdd extends StatefulWidget {
  const QuickAdd({Key? key}) : super(key: key);

  @override
  State<QuickAdd> createState() => _QuickAddState();
}

class _QuickAddState extends State<QuickAdd> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth - ((screenWidth / 3.5) + 40);
    int crossAxisCount = 1;
    if (screenWidth > 600) {
      crossAxisCount = 2;
    }
    double dynamicAspectRatio = screenHeight > screenWidth
        ? (screenWidth / (screenHeight))
        : (screenHeight / (screenWidth / 1.5));
    final textThemeRef = Theme.of(context).textTheme;
    double logoWidth = screenWidth / 4;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 4;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => PrinterDialog(),
              );
            },
            onDoubleTap: () {
              setState(() {
                refreshData();
                Fluttertoast.showToast(
                    msg:
                        "Data Refresh in Progress. Switch pages for changes to appear.");
              });
              print("Data Refreshed");
            },
            child: Image.asset(
              'assets/trustdine_logo.png',
              width: logoWidth,
            ),
          ),
        ),
        backgroundColor: Colors.white,
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
                "QUICK CHECKOUT",
                // style: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: true,
                  // barrierLabel: text,
                  showDragHandle: true,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  isDismissible: true,
                  context: context,
                  builder: (context) {
                    double imgSize = screenHeight > screenWidth
                        ? (screenWidth / 4)
                        : (screenHeight / 4);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        height: screenHeight / 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Your Cart",
                                    style: textThemeRef.headline6!.copyWith(
                                        fontFamily: "Montserrat_Bold"),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      primary: const Color(0xFF22A45D),
                                      // fixedSize: const Size(120, 40),
                                      side: const BorderSide(
                                          color: Color(0xFF22A45D)),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (CartManager()
                                          .addedProducts
                                          .isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyApp(),
                                            ));
                                        double finalPrice = double.parse(
                                            CartManager()
                                                .calculateTotalPrice()
                                                .toStringAsFixed(2));
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckOutPage(
                                                paymentAmount: finalPrice,
                                                logoWidth: logoWidth,
                                              ),
                                            ));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Please add items to cart to proceed!",
                                          timeInSecForIosWeb: 4,
                                        );
                                      }
                                    },
                                    child: const Text("Proceed To Checkout"),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Grand Total: ₹ ${CartManager().calculateTotalPrice().toStringAsFixed(2)}",
                                    style: textThemeRef.headline6!.copyWith(
                                        fontFamily: "Montserrat_Bold"),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      primary: const Color(0xFF22A45D),
                                      // fixedSize: const Size(120, 40),
                                      side: const BorderSide(
                                          color: Color(0xFF22A45D)),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      CoolAlert.show(
                                        title: "TO MANAGE CART",
                                        text:
                                            "Select Cart from bottom to make changes!",
                                        context: context,
                                        type: CoolAlertType.info,
                                      );
                                    },
                                    child: const Text("Make Changes to Cart"),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CartManager().addedProducts.isNotEmpty
                                  ? Column(
                                      children: List.generate(
                                          CartManager().addedProducts.length,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    // right: defaultPadding,
                                                    // left: defaultPadding,
                                                    bottom: 6.0),
                                                child: NetworkCartCardNoIcon(
                                                  imgSize: imgSize,
                                                  image: CartManager()
                                                      .addedProducts[index]
                                                      .imagePath,
                                                  title: CartManager()
                                                      .addedProducts[index]
                                                      .productName,
                                                  price: CartManager()
                                                      .addedProducts[index]
                                                      .price,
                                                  quantity: CartManager()
                                                      .addedProducts[index]
                                                      .quantity,
                                                  size: CartManager()
                                                      .addedProducts[index]
                                                      .size,
                                                  screenWidth: screenWidth,
                                                  decreaseButton: () {
                                                    _deductItem(
                                                        index, setState);
                                                  },
                                                  deleteButton: () {
                                                    // Pass setState to trigger a rebuild
                                                    _removeProduct(
                                                        index, setState);
                                                  },
                                                ),
                                              )),
                                    )
                                  : Text(
                                      "Your Cart is empty!",
                                      style: textThemeRef.headline6!.copyWith(
                                          fontFamily: "Montserrat_Bold"),
                                    )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 20, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SidePanel(onCategorySelected: _onCategorySelected),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: screenHeight,
                  width: containerWidth,
                  color: Colors.grey.shade200,
                  child: selectedCategory.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: screenHeight / 4,
                            crossAxisCount:
                                crossAxisCount, // Number of columns in the grid
                            crossAxisSpacing: 8.0, // Spacing between columns
                            mainAxisSpacing: 8.0, // Spacing between rows
                          ),
                          shrinkWrap: true,
                          itemCount: selectedCategory.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(15),
                              minVerticalPadding: 0,
                              title: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                  height: screenHeight / 8,
                                  child: CachedNetworkImage(
                                    // width: screenHeight / 8,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                      child: Icon(Icons.error),
                                    ),
                                    imageUrl: selectedCategory[index]['image'],
                                    fadeInDuration:
                                        const Duration(microseconds: 1),
                                  ),
                                ),
                              ),
                              subtitle: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                minVerticalPadding: 10,
                                title: Text(
                                  selectedCategory[index]['name'],
                                  style: textThemeRef.bodyLarge!
                                      .copyWith(fontFamily: "Montserrat_Bold"),
                                ),
                                trailing: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: const Color(0xFF22A45D),
                                    // fixedSize: const Size(120, 40),
                                    side: const BorderSide(
                                        color: Color(0xFF22A45D)),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  child: const Text(
                                    "ADD TO CART",
                                    // style: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    print("clicked");
                                    final productToAdd = AddedProduct(
                                      selectedCategory[index]['name'],
                                      selectedCategory[index]['price'],
                                      1,
                                      selectedCategory[index]['image'],
                                      selectedCategory[index]['size'],
                                      selectedCategory[index]['type'],
                                    );
                                    CartManager().addProduct(productToAdd);
                                    CoolAlert.show(
                                      width: screenWidth / 2,
                                      title: "Added to Cart",
                                      context: context,
                                      backgroundColor: const Color(0xFF22A45D),
                                      type: CoolAlertType.success,
                                      text:
                                          "1 ${selectedCategory[index]['name']} added to cart",
                                      lottieAsset:
                                          "assets/illustrations/food_loading.json",
                                      confirmBtnColor: const Color(0xFF22A45D),
                                    );
                                    print(CartManager().addedProducts.length);
                                  },
                                ),
                                subtitle: Text(
                                    "₹ ${selectedCategory[index]['price']}"),
                              ),

                              // Other product details or actions
                            );
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Lottie.asset(
                                "assets/illustrations/Empty_Girl.json",
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "No items found...!\nPlease select another category",
                              style: textThemeRef.headline6!
                                  .copyWith(fontFamily: "Montserrat_Bold"),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(List<Map<String, dynamic>> category) {
    setState(() {
      selectedCategory = category;
    });
  }

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

class SidePanel extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCategorySelected;

  const SidePanel({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: screenWidth / 4.5,
        height: screenHeight,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                categoriesList.length,
                (index) => GestureDetector(
                  onTap: () {
                    widget.onCategorySelected(
                      productsByCategory[categoriesList[index]['name']] ?? [],
                    );
                  },
                  child: PanelCard(
                    imageUrl: categoriesList[index]['image'],
                    cardName: categoriesList[index]['name'],
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
