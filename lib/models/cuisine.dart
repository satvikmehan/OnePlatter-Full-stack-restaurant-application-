class  Dish {
  final String id, name, imageUrl, price, rating, cuisineId;

  Dish({required this.id, required this.name, required this.imageUrl, required this.price, required this.rating,required this.cuisineId});

  factory Dish.fromJson(Map<String, dynamic> json,String cuisineId) {
    return Dish(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: json['image_url'],
      price: json['price'].toString(),
      rating: json['rating'].toString(),
      cuisineId: cuisineId,
    );
  }
}

class Cuisine {
  final String id, name, imageUrl;
  final List<Dish> items;

  Cuisine({required this.id, required this.name, required this.imageUrl, required this.items});

  factory Cuisine.fromJson(Map<String, dynamic> json,) {
    final cuisineId = json['cuisine_id'].toString();
    var itemList = (json['items'] as List).map((item) => Dish.fromJson(item,cuisineId)).toList();
    return Cuisine(
      id: cuisineId,
      name: json['cuisine_name'],
      imageUrl: json['cuisine_image_url'],
      items: itemList,
    );
  }
}

class CartItem {
  final String cuisineId;
  final String itemId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.cuisineId,
    required this.itemId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}