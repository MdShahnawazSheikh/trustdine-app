import 'package:trustdine/backend/central_api.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/storage/cache.dart';

void sendRevenueData(double amount) async {
  String? token = await SecureStorageManager.getToken() as String;
  try {
    // double amount = 20000; // The revenue amount you want to send
    String authToken = token; // Replace with the actual auth token

    Map<String, dynamic> response = await sendRevenue(amount, authToken);

    // Handle the response as needed
    print('Revenue sent successfully: $response');
  } catch (e) {
    print('Error sending revenue: $e');
    // Handle the error...
  }
}

Future<void> fetchData() async {
  String? token = await SecureStorageManager.getToken() as String;
  InvoiceData = await fetchInvoices(token!);
  try {
    allProducts.clear();
  } catch (e) {}
  productsByCategory.clear();
  if (categoriesList.isNotEmpty) {
    categoriesList.clear();
  }
  /* if (PizzaData.isNotEmpty) {
    PizzaData.clear();
    PizzaVeg.clear();
    PizzaNonVeg.clear();
  } */
  /*  if (BurgerData.isNotEmpty) {
    BurgerData.clear();
    BurgerVeg.clear();
    BurgerNonVeg.clear();
  } */
  if (CarouselData.isNotEmpty) {
    CarouselData.clear();
  }
  if (FeaturedFoods.isNotEmpty) {
    FeaturedFoods.clear();
  }
  if (SpotlightFoods.isNotEmpty) {
    SpotlightFoods.clear();
  }

  final response = await fetchAllFoods(
      token); // Replace 'API_ENDPOINT' with the actual API endpoint
  final carousels = await fetchAllCarousel(token);
  final categories = await fetchCategories(token);
  try {
    userDetails = await getUser(token);
  } catch (e) {
    print(e);
  }
  try {
    List<dynamic> invoiceDetails = await fetchInvoices(token);
    InvoiceData = invoiceDetails;
  } catch (e) {
    print(e);
  }
  // Fetching Categories
  try {
    for (var element in categories) {
      Map<String, dynamic> categoryData = {
        'name': element['categoryName'],
        'image': element['categoryImg'],
      };
      categoriesList.add(categoryData);
    }
  } catch (e) {
    throw Exception('Failed to load data');
  }

  // All products
  try {
    productNames.clear();
  } catch (e) {}
  allProducts = response;
  for (var product in allProducts) {
    productNames.add(product['foodName']);
  }
  // Fetching Carousels and Foods
  try {
    for (var item in carousels) {
      CarouselData.add(item['carouselImage']);
    }
    for (var food in response) {
      Map<String, dynamic> foodData = {
        'name': food['foodName'],
        'image': food['foodImg'],
        'rating': "not applicable on this app",
        'size': food['foodSize'],
        'price': double.parse(food['foodPrice']),
        'category': food['categoryName'],
        'description': food['foodDisc'],
        'id': food['_id'],
        'type': food['foodType'],
        'featured': food['featured'],
        'spotlight': food['spotlight']
      };

      try {
        String category = food['categoryName'];
        if (!productsByCategory.containsKey(category)) {
          productsByCategory[category] = [];
        }
        productsByCategory[category]?.add(foodData);
      } catch (e) {
        throw Exception("$e occured while making productsByCategory");
      }

      if (foodData['featured'] == true) {
        FeaturedFoods.add(foodData);
      }
      if (foodData['spotlight'] == true) {
        SpotlightFoods.add(foodData);
      }

      if (food['categoryName'] == 'Pizza') {
        PizzaData.add(foodData);
        if (food['foodType'] == 'veg' ||
            food['foodType'] == "Veg" ||
            food['foodType'] == "VEG") {
          PizzaVeg.add(foodData);
        } else {
          PizzaNonVeg.add(foodData);
        }
      } else if (food['categoryName'] == 'Burger') {
        BurgerData.add(foodData);
        if (food['foodType'] == 'veg' ||
            food['foodType'] == "Veg" ||
            food['foodType'] == "VEG") {
          BurgerVeg.add(foodData);
        } else {
          BurgerNonVeg.add(foodData);
        }
      }
    }
    // print(PizzaData);
  } catch (e) {
    throw Exception('Failed to load data');
  }
  // for (var product in productsByCategory['Pizza']!) {
  //   print(product['name']);
  // }
}

bool checkExisting(String iD, List data) {
  for (var food in data) {
    if (iD == food['id']) {
      return true;
    }
  }
  return false;
}

void refreshData() async {
  PizzaData.clear();
  BurgerData.clear();
  CarouselData.clear();
  await fetchData();
}
