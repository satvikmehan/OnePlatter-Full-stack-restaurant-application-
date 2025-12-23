import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onebanc_application/models/cuisine.dart';

class ApiService  {

  static const String baseUrl = "https://uat.onebanc.ai/emulator/interview/";
  static const Map<String, String> baseHeaders = {
    "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
    "X-Forward-Proxy-Action": "get_item_list",
    "Content-Type": "application/json"
  };

  static Future<List<Cuisine>> fetchCuisines() async {
  int page = 1;
  int pageSize = 7;
  List<Cuisine> allCuisines = [];

  while (true) {
    final response = await http.post(
      Uri.parse("${baseUrl}get_item_list"),
      headers: baseHeaders,
      body: jsonEncode({"page": page, "count": pageSize}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List cuisines = data['cuisines'];
      final int totalPages = data['total_pages'] ?? 1;

      if (cuisines.isEmpty) {
        break;
      }
      allCuisines.addAll(cuisines.map((e) => Cuisine.fromJson(e)).toList());
      if (page >= totalPages) {
        break;
      }
      page++;
    } else {
      throw Exception("Failed to load cuisines");
    }
  }
  return allCuisines;
}

  static Future<Map<String, dynamic>> placeOrder(List<CartItem> cartItems) async {
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.total);
    final cgst = totalAmount * 0.025;
    final sgst = totalAmount * 0.025;
    final grandTotal = totalAmount + cgst + sgst;
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    final payload = {
      "total_amount": grandTotal,
      "total_items": totalItems,
      "data": cartItems.map((item) {
        return {
          "cuisine_id": int.tryParse(item.cuisineId) ?? 0,
          "item_id": int.tryParse(item.itemId) ?? 0,
          "item_price": item.price,
          "item_quantity": item.quantity,
        };
      }).toList()
    };

    final response = await http.post(
      Uri.parse("${baseUrl}make_payment"),
      headers: {
        "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
        "X-Forward-Proxy-Action": "make_payment",
        "Content-Type": "application/json"
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Order failed: ${response.body}");
    }
  }

static Future<List<Dish>> fetchAllDishes() async {
  int page = 1;
  int count = 7;
  List<Dish> allDishes = [];

while(true){
  final response = await http.post(
    Uri.parse("https://uat.onebanc.ai/emulator/interview/get_item_list"),
    headers: {
      "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
      "X-Forward-Proxy-Action": "get_item_list",
      "Content-Type": "application/json"
    },
    body: jsonEncode({"page": page, "count": count}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final cuisines = data['cuisines'] as List;

    for (var cuisine in cuisines) {
      String cuisineId = cuisine['cuisine_id'].toString();
      var items = cuisine['items'] as List;
      allDishes.addAll(items.map((e) => Dish.fromJson(e, cuisineId)));
    }

    if (page > count) {
        break; 
      }
      page++;
  } 
  else {
    throw Exception("Failed to fetch all dishes");
  }
}
return allDishes;
}

static Future<Dish> fetchDishById(String itemId) async {
  final response = await http.post(
    Uri.parse("https://uat.onebanc.ai/emulator/interview/get_item_by_id"),
    headers: {
      "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
      "X-Forward-Proxy-Action": "get_item_by_id",
      "Content-Type": "application/json"
    },
    body: jsonEncode({"item_id": int.tryParse(itemId)}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Dish(
      id: data['item_id'].toString(),
      name: data['item_name'],
      price: data['item_price'].toString(),
      rating: data['item_rating'].toString(),
      imageUrl: data['item_image_url'],
      cuisineId: data['cuisine_id'].toString(),
    );
  } else {
    throw Exception("Failed to fetch item by ID: ${response.body}");
  }
}

static Future<List<Dish>> fetchFilteredDishes({
  List<String>? cuisineTypes,
}) async {
  final Map<String, dynamic> body = {};

  if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
    body["cuisine_type"] = cuisineTypes;
  }

  if (body.isEmpty) {
    throw Exception("At least one filter must be applied.");
  }

  final response = await http.post(
    Uri.parse("https://uat.onebanc.ai/emulator/interview/get_item_by_filter"),
    headers: {
      "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
      "X-Forward-Proxy-Action": "get_item_by_filter",
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final cuisines = data["cuisines"] as List;
    List<Dish> result = [];

    for (final cuisine in cuisines) {
      final items = cuisine["items"] as List;
      for (final item in items) {
        final dishId = item['id'].toString();
        final dish = await fetchDishById(dishId); 
        result.add(dish);
      }
    }
    return result;
  } else {
    throw Exception("Failed to fetch filtered dishes");
  }
}

}
