import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trustdine/constants.dart';
import 'package:trustdine/apiData.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < CarouselData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return (CarouselData.length) > 0
        ? AspectRatio(
            aspectRatio: 1.81,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
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
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading image'));
                        } else if (snapshot.data == true) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: CarouselData[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('Failed to load image'));
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
        : const Center(
            child: Text("Please add carousel from admin panel!"),
          );
  }

  Future<bool> _imageLoadFuture(int index) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

class IndicatorDot extends StatelessWidget {
  const IndicatorDot({
    required this.isActive,
    Key? key,
  }) : super(key: key);

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
