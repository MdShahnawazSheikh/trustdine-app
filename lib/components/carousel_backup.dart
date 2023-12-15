import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/apiData.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;

  Future<bool> _imageLoadFuture(int index) async {
    // Simulate loading delay (replace this with actual image loading logic)
    await Future.delayed(Duration(seconds: 1));
    // Return true to indicate successful image loading
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return (CarouselData.length) > 0
        ? AspectRatio(
            aspectRatio: 1.81,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: CarouselData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return FutureBuilder<bool>(
                      future: _imageLoadFuture(index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.white,
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading image'));
                        } else if (snapshot.data == true) {
                          // Image has been loaded successfully
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: CarouselData[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Center(child: Text('Failed to load image'));
                        }
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: defaultPadding,
                  right: defaultPadding,
                  child: Row(
                    children: List.generate(
                      CarouselData.length,
                      (index) => Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 4),
                        child: IndicatorDot(isActive: index == _currentPage),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: Text("Please add carousel from admin panel!"),
          );
  }
}

class IndicatorDot extends StatelessWidget {
  const IndicatorDot({
    required this.isActive,
    super.key,
  });
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
