import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/circular_image_card.dart';
import 'package:trustdine/components/custom_modal_sheet.dart';
import 'package:trustdine/components/image_carousel.dart';
import 'package:trustdine/components/network_product_info_medium_card.dart';
import 'package:trustdine/components/product_info_medium_card.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/screens/products_grid/products_grid_screen.dart';

class HomeScreen extends StatefulWidget {
  final double logoWidth;
  const HomeScreen({Key? key, required this.logoWidth}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _dataFetchingFuture;

  @override
  void initState() {
    super.initState();
    _dataFetchingFuture = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    double logoWidth = screenWidth / 3;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 3;
      cardHeight = screenWidth / 2.5;
    }
    return Scaffold(
        body: FutureBuilder(
            future: _dataFetchingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        semanticsLabel: "Loading Content",
                        backgroundColor: Colors.grey,
                        color: Colors.black,
                        semanticsValue: AutofillHints.countryName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Awesomeness loading❤️",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Autour"),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError &&
                  snapshot.error.toString() !=
                      "Null check operator used on a null value") {
                print(snapshot.error);
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/illustrations/connection_lost.svg",
                              height: screenHeight > screenWidth
                                  ? (screenHeight / 3)
                                  : screenWidth / 3,
                            ),
                            Text(
                              "Lost Connection to server...\nCheck your connection or try again after sometimes.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]),
                    ),
                  ),
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    CustomSliverAppBar(logoWidth: widget.logoWidth),
                    SliverToBoxAdapter(
                      child: SizedBox(height: screenHeight / 22),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: ImageCarousel(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: SectionTitle(
                            buttonText: "See All",
                            title: "Featured Products",
                            press: () => CustomModalSheet(
                                context,
                                screenHeight,
                                screenWidth,
                                cardHeight,
                                "Featured Products",
                                FeaturedFoods)),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            FeaturedFoods.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: defaultPadding / 1.2, right: 10),
                              child: NetworkProductInfoMediumCard(
                                productName: FeaturedFoods[index]['name'],
                                image: FeaturedFoods[index]['image'],
                                press: () {},
                                rating: FeaturedFoods[index]['rating'],
                                size: FeaturedFoods[index]['size'],
                                price: FeaturedFoods[index]['price'],
                                category: FeaturedFoods[index]['category'],
                                type: FeaturedFoods[index]['type'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(
                          top: defaultPadding + 10,
                          left: defaultPadding,
                          bottom: 10),
                      sliver: SliverToBoxAdapter(
                        child: SectionTitleNoButton(
                          title: "Categories",
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        // top: defaultPadding,
                        right: defaultPadding,
                        left: 8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  categoriesList.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CategoryCircularCard(
                                      screenHeight: screenHeight,
                                      screenHWidth: screenWidth,
                                      text: categoriesList[index]['name'],
                                      imageUrl: categoriesList[index]['image'],
                                      onPress: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ProductsGridPage(
                                            products: productsByCategory[
                                                    categoriesList[index]
                                                        ['name']] ??
                                                [],
                                            category: categoriesList[index]
                                                ['name'],
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: SectionTitle(
                            buttonText: "See All",
                            title: "Food Spotlight",
                            press: () {
                              CustomModalSheet(
                                  context,
                                  screenHeight,
                                  screenWidth,
                                  cardHeight,
                                  "Pizza Spotlight",
                                  SpotlightFoods);
                            }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            SpotlightFoods.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: defaultPadding / 1.2, right: 10),
                              child: NetworkProductInfoMediumCard(
                                productName: SpotlightFoods[index]['name'],
                                image: SpotlightFoods[index]['image'],
                                press: () {},
                                rating: SpotlightFoods[index]['rating'],
                                size: SpotlightFoods[index]['size'],
                                price: SpotlightFoods[index]['price'],
                                category: SpotlightFoods[index]['category'],
                                type: SpotlightFoods[index]['type'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(
                          top: 50, left: 50, right: 50, bottom: 50),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Made with ❤️\nBy the TrustSign team.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "Autour"),
                        ),
                      ),
                    )
                  ],
                );
              }
            }));
  }
}
