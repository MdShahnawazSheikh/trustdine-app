// It contains all data that we used

List<Map<String, dynamic>> PizzaData = [];
List<Map<String, dynamic>> PizzaVeg = [];
List<Map<String, dynamic>> PizzaNonVeg = [];
List<Map<String, dynamic>> BurgerData = [];
List<Map<String, dynamic>> BurgerVeg = [];
List<Map<String, dynamic>> BurgerNonVeg = [];
List<Map<String, dynamic>> FeaturedFoods = [];
List<Map<String, dynamic>> SpotlightFoods = [];
List<Map<String, dynamic>> categoriesList = [];
List CarouselData = [];
List<dynamic> InvoiceData = [];
Map<String, dynamic> userDetails = {};

Map<String, List<Map<String, dynamic>>> productsByCategory = {};
List<String> demoBigImages = [
  "assets/images/big_1.png",
  "assets/images/big_2.png",
  "assets/images/big_3.png",
  "assets/images/big_4.png",
];

List<Map<String, dynamic>> demoMediumCardData = [
  {
    "name": "Daylight Coffee",
    "image": "assets/images/medium_1.png",
    "rating": "4.6",
    "size": "Medium",
    "price": 345.4,
    "category": 'Coffee',
  },
  {
    "name": "Mario Italiano",
    "image": "assets/images/medium_2.png",
    "size": "Large",
    "rating": "4.3",
    "price": 342.4,
    "category": 'Italy',
  },
  {
    "name": "McDonald's",
    "image": "assets/images/medium_3.png",
    "size": "Normal",
    "rating": "4.9",
    "price": 342.4,
    "category": 'Chicken Dish',
  },
  {
    "name": "The Foodie Guys",
    "image": "assets/images/medium_4.png",
    "size": "Small",
    "rating": "3.9",
    "price": 342.4,
    "category": 'Meal',
  },
];
List<Map<String, dynamic>> featuredProducts = [
  {
    "name": "Daylight Coffee",
    "image": "assets/images/medium_1.png",
    "rating": "4.6",
    "size": "Medium",
    "price": 345.4,
    "category": 'Coffee',
  },
  {
    "name": "Mario Italiano",
    "image": "assets/images/medium_2.png",
    "size": "Large",
    "rating": "4.3",
    "price": 342.4,
    "category": 'Italy',
  },
  {
    "name": "McDonald's",
    "image": "assets/images/medium_3.png",
    "size": "Normal",
    "rating": "4.9",
    "price": 342.4,
    "category": 'Chicken Dish',
  },
  {
    "name": "Sea Food",
    "image": "assets/images/medium_4.png",
    "size": "Small",
    "rating": "3.9",
    "price": 342.4,
    "category": 'Fish',
  },
  {
    "name": "Downtown Meal",
    "image": "assets/images/featured _items_1.png",
    "size": "Regular",
    "rating": "4.0",
    "price": 544.4,
    "category": 'Meal',
  },
  {
    "name": "The Foodie Guys",
    "image": "assets/images/featured _items_2.png",
    "size": "Small",
    "rating": "3.9",
    "price": 456.3,
    "category": 'Meal',
  },
  {
    "name": "Subway",
    "image": "assets/images/featured _items_3.png",
    "size": "Small",
    "rating": "3.9",
    "price": 342.4,
    "category": 'Meal',
  },
];
List<Map<String, dynamic>> demoPizzaData = [
  {
    "name": "Pizza 1",
    "image": "assets/images/pizza_1.jpg",
    "rating": "4.7",
    "size": "Regular",
    "price": 335.4,
    "category": 'Veg Pizza',
  },
  {
    "name": "Pizza 2",
    "image": "assets/images/pizza_2.jpg",
    "rating": "5.0",
    "size": "Medium",
    "price": 335.4,
    "category": 'Non-Veg Pizza',
  },
  {
    "name": "Pizza 2",
    "image": "assets/images/pizza_2.jpg",
    "rating": "5.0",
    "size": "Small",
    "price": 335.4,
    "category": 'Non-Veg Pizza',
  },
  {
    "name": "Pizza 3",
    "image": "assets/images/pizza_3.jpg",
    "rating": "4.2",
    "size": "Small",
    "price": 234.4,
    "category": 'Non-Veg Pizza',
  },
  {
    "name": "Pizza 4",
    "image": "assets/images/pizza_4.jpg",
    "rating": "4.9",
    "size": "Large",
    "price": 635.4,
    "category": 'Veg Pizza',
  },
  {
    "name": "Pizza 5",
    "image": "assets/images/pizza_5.jpg",
    "rating": "4.9",
    "size": "Large",
    "price": 635.4,
    "category": 'Veg Pizza',
  },
  {
    "name": "Pizza 6",
    "image": "assets/images/pizza_6.jpg",
    "rating": "4.9",
    "size": "Large",
    "price": 635.4,
    "category": 'Veg Pizza',
  },
  {
    "name": "Pizza 7",
    "image": "assets/images/pizza_7.jpg",
    "rating": "4.9",
    "size": "Large",
    "price": 635.4,
    "category": 'Veg Pizza',
  },
];
