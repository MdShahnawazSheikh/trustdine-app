import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;

String baseUrl = "https://trustdine.onrender.com/api";

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {"Content-Type": "application/json"},
    body: json.encode({"email": email, "password": password}),
  );
  return json.decode(response.body);
}

Future<List<dynamic>> fetchAllFoods(String authToken) async {
  final response = await http.get(
    Uri.parse('$baseUrl/foods/fetchallfoods'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken
    },
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getUser(String authToken) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/getuser'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get user: $response');
  }
}

Future<List<dynamic>> fetchCategories(String authToken) async {
  final response = await http.get(
    Uri.parse('$baseUrl/category/fetchallcategories'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken
    },
  );
  return json.decode(response.body);
}

Future<List<dynamic>> fetchInvoices(String authToken) async {
  final response = await http.get(
    Uri.parse('$baseUrl/invoice/fetch-invoice'),
    headers: {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client',
      'auth-token': authToken,
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load invoices: $response');
  }
}

Future<void> verifyEmail(String otp, String userId, String authToken) async {
  await http.post(
    Uri.parse('$baseUrl/auth/verifyemail'),
    headers: {"Content-Type": "application/json", "auth-token": authToken},
    body: json.encode({"otp": otp, "userId": userId}),
  );
}

Future<void> addCategory(String categoryId, String categoryImgPath,
    String categoryName, String authToken) async {
  var request = http.MultipartRequest(
      'PUT', Uri.parse('$baseUrl/category/updatecategory/$categoryId'));
  request.headers.addAll({
    "Accept": "*/*",
    "User-Agent": "Thunder Client",
    "auth-token": authToken
  });
  request.fields['categoryName'] = categoryName;
  request.files
      .add(await http.MultipartFile.fromPath('categoryImg', categoryImgPath));
  await request.send();
}

Future<void> addFood(
    String foodImgPath,
    String foodName,
    String foodPrice,
    String foodDiscount,
    String foodType,
    String foodSize,
    String categoryId,
    String categoryName,
    String foodDisc,
    String authToken) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/foods/addfood'));
  request.headers.addAll({
    "Accept": "*/*",
    "User-Agent": "Thunder Client",
    "auth-token": authToken
  });
  request.fields.addAll({
    'foodName': foodName,
    'foodPrice': foodPrice,
    'foodDiscount': foodDiscount,
    'foodType': foodType,
    'foodSize': foodSize,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'foodDisc': foodDisc,
  });
  request.files.add(await http.MultipartFile.fromPath('foodImg', foodImgPath));
  await request.send();
}

Future<void> updateFood(
    String foodId,
    String foodImgPath,
    String foodName,
    String foodPrice,
    String foodDiscount,
    String foodType,
    String foodSize,
    String categoryId,
    String categoryName,
    String foodDisc,
    String authToken) async {
  var request = http.MultipartRequest(
      'PUT', Uri.parse('$baseUrl/foods/updatefood/$foodId'));
  request.headers.addAll({
    "Accept": "*/*",
    "User-Agent": "Thunder Client",
    "auth-token": authToken
  });
  request.fields.addAll({
    'foodName': foodName,
    'foodPrice': foodPrice,
    'foodDiscount': foodDiscount,
    'foodType': foodType,
    'foodSize': foodSize,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'foodDisc': foodDisc,
  });
  request.files.add(await http.MultipartFile.fromPath('foodImg', foodImgPath));
  await request.send();
}

Future<List<dynamic>> fetchAllCarousel(String authToken) async {
  final response = await http.get(
    Uri.parse('$baseUrl/carousel/fetchallcarousel'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken
    },
  );
  return json.decode(response.body);
}

Future<void> addCarousel(String carouselImgPath, String authToken) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/carousel/addcarousel'));
  request.headers.addAll({
    "Accept": "*/*",
    "User-Agent": "Thunder Client",
    "auth-token": authToken
  });
  request.files
      .add(await http.MultipartFile.fromPath('carouselImage', carouselImgPath));
  await request.send();
}

Future<void> updateCarousel(
    String carouselId, String carouselImgPath, String authToken) async {
  var request = http.MultipartRequest(
      'PUT', Uri.parse('$baseUrl/carousel/updateCarousel/$carouselId'));
  request.headers.addAll({
    "Accept": "*/*",
    "User-Agent": "Thunder Client",
    "auth-token": authToken
  });
  request.files
      .add(await http.MultipartFile.fromPath('carouselImage', carouselImgPath));
  await request.send();
}

Future<Map<String, dynamic>> sendRevenue(
    double amount, String authToken) async {
  final response = await http.post(
    Uri.parse('$baseUrl/revenue/add-revenue'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
      "Content-Type":
          "application/json", // Specify the content type for the request
    },
    body: json.encode({"amount": amount}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to send revenue: $response');
  }
}

Future<Map<String, dynamic>> sendOrder(String authToken, String orderId,
    List<Map<String, String>> orderItems) async {
  final response = await http.post(
    Uri.parse('$baseUrl/order/add-order'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
      "Content-Type":
          "application/json", // Specify the content type for the request
    },
    body: json.encode({
      "orderId": orderId,
      "orderItems": orderItems,
    }),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to send order: $response');
  }
}
