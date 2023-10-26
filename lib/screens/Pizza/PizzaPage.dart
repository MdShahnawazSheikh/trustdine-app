import 'package:flutter/material.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/components/NetworkProductCardTwoRow.dart';
import 'package:trustdine/components/ProductCardTwoRow.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/custom_modal_sheet.dart';
import 'package:trustdine/components/network_product_info_medium_card.dart';
import 'package:trustdine/components/product_info_medium_card.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/apiData.dart';

class PizzaPage extends StatefulWidget {
  final double logoWidth;
  const PizzaPage({super.key, required this.logoWidth});

  @override
  State<PizzaPage> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<PizzaPage> {
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
                title: "Veg Pizza",
                press: () {
                  CustomModalSheet(
                    context,
                    screenHeight,
                    screenWidth,
                    cardHeight,
                    "Veg Pizza",
                    PizzaVeg,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  PizzaVeg.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                        left: defaultPadding / 1.2, right: 10),
                    child: NetworkProductInfoMediumCard(
                      productName: PizzaVeg[index]['name'],
                      image: PizzaVeg[index]['image'],
                      press: () {},
                      rating: PizzaVeg[index]['rating'],
                      size: PizzaVeg[index]['size'],
                      price: PizzaVeg[index]['price'],
                      category: PizzaVeg[index]['category'],
                      type: PizzaVeg[index]['type'],
                      description: PizzaVeg[index]['description'],
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
                title: "Non-Veg Pizza",
                press: () {
                  CustomModalSheet(
                    context,
                    screenHeight,
                    screenWidth,
                    cardHeight,
                    "Non-Veg Pizza",
                    PizzaNonVeg,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  PizzaNonVeg.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                        left: defaultPadding / 1.2, right: 10),
                    child: NetworkProductInfoMediumCard(
                      productName: PizzaNonVeg[index]['name'],
                      image: PizzaNonVeg[index]['image'],
                      press: () {},
                      rating: PizzaNonVeg[index]['rating'],
                      size: PizzaNonVeg[index]['size'],
                      price: PizzaNonVeg[index]['price'],
                      category: PizzaNonVeg[index]['category'],
                      type: PizzaNonVeg[index]['type'],
                      description: PizzaNonVeg[index]['description'],
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
              child: SectionTitleNoButton(title: "Browse All Pizza"),
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
                  itemCount: PizzaData.length,
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
                      image: PizzaData[index]['image'],
                      name: PizzaData[index]['name'],
                      category: PizzaData[index]['category'],
                      size: PizzaData[index]['size'],
                      price: PizzaData[index]['price'],
                      rating: PizzaData[index]['rating'],
                      type: PizzaData[index]['type'],
                      description: PizzaData[index]['description'],
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
