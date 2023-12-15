import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/printer/printer_dialog.dart';
import 'package:trustdine/screens/SlideShow/slideshow_screen.dart';

class CustomSliverAppBar extends StatefulWidget {
  final double logoWidth;

  const CustomSliverAppBar({super.key, required this.logoWidth});

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      elevation: 0,
      floating: true,
      title: Padding(
        padding: EdgeInsets.only(
          bottom: 8,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SlideShowScreen(),
                ));
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => PrinterDialog(),
            );
          },
          onDoubleTap: () {
            setState(() {
              refreshData();
              Fluttertoast.showToast(
                  msg:
                      "Data Refresh in Progress. Switch pages for changes to appear.");
            });
            print("Data Refreshed");
          },
          child: Image.asset(
            'assets/trustdine_logo.png',
            width: widget.logoWidth,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
