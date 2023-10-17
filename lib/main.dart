import 'package:firebase_core/firebase_core.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trustdine/backend/central_api.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/screens/Burger/BurgerPage.dart';
import 'package:trustdine/screens/Cart/CartPage.dart';
import 'package:trustdine/screens/Drinks/DrinksPage.dart';
import 'package:trustdine/screens/Pizza/PizzaPage.dart';
import 'package:trustdine/screens/auth/login_screen.dart';
import 'package:trustdine/screens/home/home_screen.dart';
import 'package:trustdine/storage/cache.dart';
import 'package:trustdine/theme.dart';
import 'firebase_options.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await SecureStorageManager.getToken();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null ? MyApp() : LoginScreen(),
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
}

class MyAppWrapper extends StatelessWidget {
  final String? token;

  MyAppWrapper(this.token);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview
          .appBuilder, // Wrap your MaterialApp builder with DevicePreview.appBuilder
      debugShowCheckedModeBanner: false,
      home: token != null ? MyApp() : LoginScreen(),
    );
  }
}
 */
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
      statusBarColor: Colors.white,
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

class _HomeScreenNavigationState extends State<HomeScreenNavigation> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth / 3;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 3;
    }
    return Scaffold(
      bottomNavigationBar: FloatingNavbar(
        borderRadius: 8,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.local_pizza, title: 'Pizza'),
          FloatingNavbarItem(icon: FontAwesomeIcons.burger, title: 'Burger'),
          FloatingNavbarItem(
              icon: FontAwesomeIcons.bottleWater, title: 'Drinks'),
          FloatingNavbarItem(icon: Icons.shopping_cart, title: 'Cart'),
        ],
      ),
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return PageView(
            controller: _pageController,
            children: [
              HomeScreen(
                logoWidth: logoWidth,
              ),
              PizzaPage(
                logoWidth: logoWidth,
              ),
              BurgerPage(
                logoWidth: logoWidth,
              ),
              DrinksPage(
                logoWidth: logoWidth,
              ),
              CartPage(
                logoWidth: logoWidth,
              ),
              // Add other screens here
            ],
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
