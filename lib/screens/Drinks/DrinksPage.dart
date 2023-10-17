import 'package:flutter/material.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/components/NetworkProductCardTwoRow.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/components/section_title.dart';
import 'package:trustdine/constants.dart';

class DrinksPage extends StatefulWidget {
  final double logoWidth;
  const DrinksPage({super.key, required this.logoWidth});

  @override
  State<DrinksPage> createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight / 3;
    if (screenWidth > screenHeight) {
      cardHeight = screenWidth / 2.5;
    }
    return Scaffold(
      body: CustomScrollView(slivers: [
        CustomSliverAppBar(logoWidth: widget.logoWidth),
        SliverPadding(
          padding: EdgeInsets.only(
              top: defaultPadding, left: defaultPadding, right: defaultPadding),
          sliver: SliverToBoxAdapter(
            child: SectionTitleNoButton(
                title: "Browse All ${categoriesList[3]['name']}"),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 1.2),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productsByCategory['Drinks']?.length,
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
                    image: productsByCategory['Drinks']?[index]['image'],
                    name: productsByCategory['Drinks']?[index]['name'],
                    category: productsByCategory['Drinks']?[index]['category'],
                    size: productsByCategory['Drinks']?[index]['size'],
                    price: productsByCategory['Drinks']?[index]['price'],
                    rating: productsByCategory['Drinks']?[index]['rating'],
                    type: productsByCategory['Drinks']?[index]['type'],
                  );
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}
