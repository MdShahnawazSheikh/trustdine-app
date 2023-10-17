import 'package:flutter/material.dart';

class CategoryCircularCard extends StatelessWidget {
  final double screenHeight;
  final double screenHWidth;
  final String text;
  final VoidCallback onPress;
  final String imageUrl;
  const CategoryCircularCard({
    super.key,
    required this.screenHeight,
    required this.screenHWidth,
    required this.text,
    required this.onPress,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: CircleAvatar(
        backgroundColor:
            Colors.transparent, // Set background color to transparent
        radius: screenHeight > screenHWidth
            ? screenHeight / 15
            : screenHWidth /
                20, // Set the radius of the circle avatar as needed
        child: ClipOval(
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Adjust the opacity as needed
                  BlendMode
                      .darken, // You can use different BlendModes for different effects
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit
                      .cover, // You can adjust the BoxFit as per your requirement
                  width:
                      double.infinity, // Set the width of the image as needed
                  height:
                      double.infinity, // Set the height of the image as needed
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontSize: screenHeight / 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
