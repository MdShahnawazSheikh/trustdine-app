import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/screens/ProductsDetailsPage/details_component.dart';
import 'package:trustdine/screens/ProductsDetailsPage/product_tile.dart';

class ProductDetails extends StatefulWidget {
  final String image, name, category, size, description, type;
  final double price;
  const ProductDetails({
    super.key,
    required this.image,
    required this.name,
    required this.category,
    required this.price,
    required this.size,
    required this.description,
    required this.type,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double image_height =
        screenHeight > screenWidth ? screenHeight / 3.5 : screenHeight / 1.8;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            expandedHeight: image_height,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset("assets/icons/back.svg"),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverToBoxAdapter(
            child: DetailsCard(
              image: widget.image,
              name: widget.name,
              price: widget.price,
              category: widget.category,
              size: widget.size,
              description: widget.description,
              type: widget.type,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
              child: Text(
                "Products You Might Like",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.grey.shade800),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: FeaturedFoods.length,
            (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
              child: ProductTileCard(
                builderObject: FeaturedFoods,
                imgSize: 60,
                image: FeaturedFoods[index]['image'],
                title: FeaturedFoods[index]['name'],
                price: FeaturedFoods[index]['price'],
                screenWidth: screenWidth,
                size: FeaturedFoods[index]['size'],
                type: FeaturedFoods[index]['type'],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
