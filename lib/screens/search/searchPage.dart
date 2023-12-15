import 'package:flutter/material.dart';
import 'package:trustdine/components/app_bar.dart';
import 'package:trustdine/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    return Scaffold(
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
              child: TextField(
                onChanged: (query) {
                  // Implement search logic based on the entered query
                  onSearch(query);
                  print(query);
                },
                cursorColor: kActiveColor,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white, // Set the background color to black
                  hintText: 'Search...',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: kActiveColor, // Set the border color when focused
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
