import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/components/NetworkProductCardTwoRow.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/circular_image_card.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/screens/products_grid/products_grid_screen.dart';

class CategoriesPage extends StatefulWidget {
  final double logoWidth;
  const CategoriesPage({super.key, required this.logoWidth});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
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
        body: categoriesList.length > 0
            ? CustomScrollView(
                slivers: [
                  CustomSliverAppBar(logoWidth: widget.logoWidth),
                  const SliverPadding(
                    padding: EdgeInsets.only(
                      top: defaultPadding,
                      left: defaultPadding,
                      right: defaultPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SectionTitleNoButton(title: "All Categories"),
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
                          itemCount: categoriesList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: screenHeight > screenWidth
                                ? (screenHeight / 5)
                                : screenHeight / 2.5,
                          ),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(0.0),
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
                  )
                ],
              )
            : CustomScrollView(slivers: [
                CustomSliverAppBar(logoWidth: widget.logoWidth),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/illustrations/empty_category.svg"),
                        Text(
                          "No categories found!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
      ),
    );
  }
}
