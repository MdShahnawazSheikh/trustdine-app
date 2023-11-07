import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/circular_image_card.dart';
import 'package:trustdine/components/custom_modal_sheet.dart';
import 'package:trustdine/components/image_carousel.dart';
import 'package:trustdine/components/network_product_info_medium_card.dart';
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
    double logoWidth = screenWidth / 3;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 3;
      cardHeight = screenWidth / 2.5;
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
                          FeaturedFoods,
                        )),
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
              padding:
                  EdgeInsets.only(left: defaultPadding, bottom: 15, top: 30),
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
              padding: const EdgeInsets.all(defaultPadding),
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
              padding: EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Made with ❤️\nBy the TrustSign team.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
