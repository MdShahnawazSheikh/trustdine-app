import 'package:trustdine/backend/central_api.dart';
import 'package:trustdine/backend/database_manager.dart';
import 'package:trustdine/storage/cache.dart';

class CartManager {
  // List to store added products

  final List<AddedProduct> _addedProducts = [];

  // Getter for accessing addedProducts
  List<AddedProduct> get addedProducts => _addedProducts;

  // Function to add a product to the cart
  void addProduct(AddedProduct product) {
    // Check if a product with the same name and size exists in the cart
    final existingProductIndex = _addedProducts.indexWhere(
      (addedProduct) =>
          addedProduct.productName == product.productName &&
          addedProduct.size == product.size,
    );

    if (existingProductIndex != -1) {
      // If the product already exists, increase its quantity
      _addedProducts[existingProductIndex].quantity += product.quantity;
      _addedProducts[existingProductIndex].price += product.price;
    } else {
      // If the product doesn't exist, add it to the cart
      _addedProducts.add(product);
    }
  }

  Map<String, Map<String, dynamic>> cartData = {};
  List<Map<String, String>> orderItems = [];
  void pushCartToFirestore(String orderId, String ModeOfPayment) async {
    // Create a map to store the cart data

    for (AddedProduct product in _addedProducts) {
      // Use the product name as the key and store product details as a map
      cartData["${product.productName} - ${product.size}"] = {
        'Size': product.size,
        'Price': product.price,
        'Quantity': product.quantity,
        'payment mode': ModeOfPayment,
        'fulfilled': 'no'
      };
      Map<String, String> productMap = {
        "foodImg": product.imagePath,
        "foodName": product.productName,
        "foodType":
            product.type, // You might need to specify the food type here
        "foodSize": product.size,
        "foodQuantity": product.quantity.toString()
      };
      orderItems.add(productMap);
    }

    // Call the DatabaseManager to add the cart data to Firestore
    await DatabaseManager().addData(orderId, cartData);

    // Sending to api
    String? token = await SecureStorageManager.getToken() as String;
    // Send the order data using the sendOrder function
    try {
      Map<String, dynamic> response =
          await sendOrder(token, orderId, orderItems);
      print('Order sent successfully: $response');
      // If you want to handle the response further, you can do it here
    } catch (e) {
      print('Failed to send order: $e');
      // Handle the error here
    }
  }

  void deductQuantity(int index) {
    if (index >= 0 && index < _addedProducts.length) {
      final product = _addedProducts[index];

      if (product.quantity > 1) {
        // Decrease the quantity by 1
        product.quantity--;

        // Adjust the price
        product.price -= (product.price / (product.quantity + 1));
      } else if (product.quantity == 1) {
        // If quantity is 1, remove the product from the cart
        removeProduct(index);
      }
    }
  }

  // Function to remove a product from the cart
  void removeProduct(int index) {
    _addedProducts.removeAt(index);
  }

  // Function to clear the cart
  void clearCart() {
    _addedProducts.clear();
    cartData.clear();
    orderItems.clear();
  }

  double calculateTotalPrice() {
    double total = 0.0;

    for (AddedProduct product in _addedProducts) {
      total += product.price;
    }

    return total;
  }

  // Singleton instance for CartManager
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();
}

class AddedProduct {
  final String imagePath;
  final String productName;
  double price;
  final String size;
  int quantity;
  String type;

  AddedProduct(this.productName, this.price, this.quantity, this.imagePath,
      this.size, this.type);
}
