import 'package:flutter/material.dart';
import 'package:trustdine/components/NetworkProductCardTwoRow.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/network_product_info_medium_card.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/apiData.dart';

class BurgerPage extends StatefulWidget {
  final double logoWidth;
  const BurgerPage({super.key, required this.logoWidth});

  @override
  State<BurgerPage> createState() => _BurgerPageState();
}

class _BurgerPageState extends State<BurgerPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
      cardHeight = screenWidth / 2.5;
    }
    try {
      return Scaffold(
          body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            logoWidth: widget.logoWidth,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(defaultPadding),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(
                buttonText: "See All",
                title: "Veg Burger",
                press: () {},
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  BurgerVeg.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                        left: defaultPadding / 1.2, right: 10),
                    child: NetworkProductInfoMediumCard(
                      productName: BurgerVeg[index]['name'],
                      image: BurgerVeg[index]['image'],
                      press: () {},
                      rating: BurgerVeg[index]['rating'],
                      size: BurgerVeg[index]['size'],
                      price: BurgerVeg[index]['price'],
                      category: BurgerVeg[index]['category'],
                      type: BurgerVeg[index]['type'],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(defaultPadding),
            sliver: SliverToBoxAdapter(
              child: SectionTitle(
                buttonText: "See All",
                title: "Non-Veg Burger",
                press: () {},
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  BurgerNonVeg.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                        left: defaultPadding / 1.2, right: 10),
                    child: NetworkProductInfoMediumCard(
                      productName: BurgerNonVeg[index]['name'],
                      image: BurgerNonVeg[index]['image'],
                      press: () {},
                      rating: BurgerNonVeg[index]['rating'],
                      size: BurgerNonVeg[index]['size'],
                      price: BurgerNonVeg[index]['price'],
                      category: BurgerNonVeg[index]['category'],
                      type: BurgerNonVeg[index]['type'],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(
                top: defaultPadding + 30,
                left: defaultPadding,
                right: defaultPadding),
            sliver: SliverToBoxAdapter(
              child: SectionTitleNoButton(title: "Browse All Burger"),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 1.2),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: BurgerData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: screenHeight > screenWidth
                        ? (screenHeight / 3)
                        : screenHeight / 1.5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return NetworkProductCardTwoRow(
                      onPress: () {},
                      image: BurgerData[index]['image'],
                      name: BurgerData[index]['name'],
                      category: BurgerData[index]['category'],
                      size: BurgerData[index]['size'],
                      price: BurgerData[index]['price'],
                      rating: BurgerData[index]['rating'],
                      type: BurgerData[index]['type'],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ));
    } on RangeError {
      return Scaffold(
        body: Center(
          child: Text(
            "Something went wrong!!!\nMake sure you are connected.",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
