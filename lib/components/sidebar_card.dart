import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PanelCard extends StatelessWidget {
  final String imageUrl, cardName;
  final double screenHeight, screenWidth;
  const PanelCard({
    super.key,
    required this.imageUrl,
    required this.cardName,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              width: screenWidth / 5,
              height: screenWidth / 5,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cardName,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
