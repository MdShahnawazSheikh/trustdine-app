import 'package:flutter/material.dart';
import 'package:trustdine/components/app_bar.dart';

class DrinksPage extends StatefulWidget {
  final double logoWidth;
  const DrinksPage({super.key, required this.logoWidth});

  @override
  State<DrinksPage> createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        CustomSliverAppBar(logoWidth: widget.logoWidth),
        const SliverToBoxAdapter(
          child: Center(
            child: Text("Drinks Page"),
          ),
        ),
      ]),
    );
  }
}
