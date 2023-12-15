import 'package:firebase_core/firebase_core.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/screens/Cart/CartPage.dart';
import 'package:trustdine/screens/Categories/categories_screen.dart';
import 'package:trustdine/screens/SlideShow/slideshow_screen.dart';
import 'package:trustdine/screens/auth/login_screen.dart';
import 'package:trustdine/screens/home/home_screen.dart';
import 'package:trustdine/screens/search/searchPage.dart';
import 'package:trustdine/storage/cache.dart';
import 'package:trustdine/test_page.dart';
import 'package:trustdine/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await SecureStorageManager.getToken();
  /* if (token != null) {
    InvoiceData = await fetchInvoices(token!);
  } */
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null ? const MyApp() : const LoginScreen(),
    /* home: DevicePreview(
      enabled: true,
      builder: (context) => token != null ? const MyApp() : const LoginScreen(),
    ), */
  ));
}

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await SecureStorageManager.getToken();

  runApp(
    DevicePreview(
      enabled: true, // Set this to true to enable device preview
      builder: (context) => MyAppWrapper(token),
    ),
  );
} */

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // print(loginUser("admin@gmail.com", "admin")); //need help printing here
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      // start
      /* useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), */
      // end
      debugShowCheckedModeBanner: false,
      title: 'TrustDine',
      theme: buildThemeData(),
      home: const HomeScreenNavigation(),
    );
  }
}

class HomeScreenNavigation extends StatefulWidget {
  const HomeScreenNavigation({Key? key}) : super(key: key);

  @override
  State<HomeScreenNavigation> createState() => _HomeScreenNavigationState();
}

int selectedIndex = 0;

class _HomeScreenNavigationState extends State<HomeScreenNavigation> {
  late Future<void> _dataFetchingFuture;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _dataFetchingFuture = fetchData();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth / 4;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 4;
    }
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 20, left: 20),
        child: FloatingNavbar(
          borderRadius: 8,
          backgroundColor: Colors.black87,
          selectedItemColor: Colors.black87,
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items: [
            FloatingNavbarItem(icon: Icons.flash_on, title: 'Quick Add'),
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            // FloatingNavbarItem(icon: Icons.local_pizza, title: 'Pizza'),
            // FloatingNavbarItem(icon: FontAwesomeIcons.burger, title: 'Burger'),
            FloatingNavbarItem(
                icon: FontAwesomeIcons.boxesStacked, title: 'Categories'),
            FloatingNavbarItem(icon: Icons.shopping_cart, title: 'Cart'),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _dataFetchingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/illustrations/objects_loading.json",
                    // repeat: false,
                    height: screenHeight / 3,
                  ),
                  const Text(
                    "Awesomeness loading❤️",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Autour"),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError &&
              snapshot.error.toString() !=
                  "Null check operator used on a null value") {
            print(snapshot.error);
            return Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth / 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/illustrations/astronaut_floating_black.json",
                      ),
                      Text(
                        "You are not connected!\nCheck your connection or try again after sometimes.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () async {
                          await SecureStorageManager.deleteToken();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Try logging in again",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                if (isOrdering == false) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SlideShowScreen(),
                      ),
                    );
                  });
                }
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PageView(
                    controller: _pageController,
                    children: [
                      const QuickAdd(),
                      HomeScreen(
                        logoWidth: logoWidth,
                      ),
                      CategoriesPage(
                        logoWidth: logoWidth,
                      ),
                      CartPage(
                        logoWidth: logoWidth,
                      ),
                      // Add other screens here
                    ],
                    onPageChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
