import 'package:flutter/material.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/main.dart';
import 'package:trustdine/printer/printer_dialog.dart';
import 'package:trustdine/screens/SlideShow/slideshow_carousel.dart';

class SlideShowScreen extends StatefulWidget {
  const SlideShowScreen({super.key});

  @override
  State<SlideShowScreen> createState() => _SlideShowScreenState();
}

class _SlideShowScreenState extends State<SlideShowScreen> {
  @override
  Widget build(BuildContext context) {
    selectedIndex = 0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double logoWidth = screenWidth / 3;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 4;
    }
    double mainContainerHeight = screenHeight / 1.3;
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SizedBox(
            height: mainContainerHeight,
            child: const SlideShowImageCarousel(),
          ),
        ),
        Container(
          height: screenHeight - mainContainerHeight,
          child: Row(
            children: [
              SizedBox(
                width: screenWidth / 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/trustdine_logo.png",
                        width: logoWidth,
                      ),
                      Text(
                        "A TrustSign Company.",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontFamily: "CedarvilleCursive",
                              // color: const Color(0xFF22A45D),
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth / 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          isOrdering = true;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyApp(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(screenWidth / 3.8, screenWidth / 10),
                          primary: const Color(0xFF22A45D),
                          side: const BorderSide(color: Color(0xFF22A45D)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.start),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Start Order",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontFamily: "Montserrat_Bold",
                                    color: const Color(0xFF22A45D),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => PrinterDialog(),
                        ),
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(screenWidth / 3.5, screenWidth / 10),
                          primary: Colors.black87,
                          side: const BorderSide(color: Colors.black87),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.settings),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Accessibility",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontFamily: "Montserrat_Bold",
                                    color: Colors.black87,
                                  ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
