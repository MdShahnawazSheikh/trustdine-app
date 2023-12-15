import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/circular_image_card.dart';
import 'package:trustdine/components/custom_modal_sheet.dart';
import 'package:trustdine/components/image_carousel.dart';
import 'package:trustdine/components/network_product_info_medium_card.dart';
import 'package:trustdine/components/searchDelegate.dart';
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
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    double logoWidth = screenWidth / 4;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 4;
      cardHeight = screenWidth / 2.5;
    }
    String searchQuery = '';

    void onSearch(String query) {
      setState(() {
        searchQuery = query;
      });
    }

    return LiquidPullToRefresh(
      color: Colors.black87,
      height: screenHeight / 6,
      onRefresh: () async {
        try {
          // Call your data fetching logic here if needed
          await fetchData();
          setState(() {});
          Fluttertoast.showToast(msg: "Data refresh Successful.");
        } catch (e) {
          Fluttertoast.showToast(msg: "Failed to refresh: $e");
        }
      },
      showChildOpacityTransition: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(logoWidth: logoWidth),
            SliverToBoxAdapter(
              child: SizedBox(height: screenHeight / 30),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                right: defaultPadding,
                left: defaultPadding,
                bottom: 15,
              ),
              sliver: SliverToBoxAdapter(
                  child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: const Color(0xFF22A45D),
                  // fixedSize: const Size(120, 40),
                  side: const BorderSide(color: Color(0xFF22A45D)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.search),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Color(0xFF22A45D)),
                    ),
                  ],
                ),
                onPressed: () => showSearch(
                  context: context,
                  delegate: CustomSeatchDelegate(),
                ),
              )),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: ImageCarousel(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                right: defaultPadding,
                left: defaultPadding,
                top: defaultPadding * 2,
                bottom: defaultPadding * 2,
              ),
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
                    FeaturedFoods,
                  ),
                ),
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
                        description: FeaturedFoods[index]['description'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(
                right: defaultPadding,
                left: defaultPadding,
                top: defaultPadding * 3,
                bottom: defaultPadding * 2,
              ),
              sliver: SliverToBoxAdapter(
                child: SectionTitleNoButton(
                  title: "Categories",
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(right: defaultPadding, left: 8),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductsGridPage(
                                  products: productsByCategory[
                                          categoriesList[index]['name']] ??
                                      [],
                                  category: categoriesList[index]['name'],
                                ),
                              ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                right: defaultPadding,
                left: defaultPadding,
                top: defaultPadding * 3,
                bottom: defaultPadding * 2,
              ),
              sliver: SliverToBoxAdapter(
                child: SectionTitle(
                    buttonText: "See All",
                    title: "Products in Spotlight",
                    press: () => CustomModalSheet(context, screenHeight,
                        screenWidth, cardHeight, "Spotlight", SpotlightFoods)),
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
                        description: SpotlightFoods[index]['description'],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: 50,
                bottom: 40,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Made with ❤️\nBy the TrustSign team.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Autour'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
