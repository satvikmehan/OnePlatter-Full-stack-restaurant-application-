import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/models/cuisine.dart';
import 'package:onebanc_application/widget/dish_detail.dart';

class MenuScreen extends StatelessWidget {
  final Cuisine cuisine;
  const MenuScreen({super.key, required this.cuisine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cuisine.name)),
      body: ListView.builder(
        itemCount: cuisine.items.length,
        itemBuilder: (context, index) {
          final dish = cuisine.items[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => DishDetail(itemId: dish.id),
                );
              },
              leading: Image.network(
                dish.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(dish.name),
              subtitle: Text("₹${dish.price} • ⭐ ${dish.rating}"),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  addToCart(
                    CartItem(
                      cuisineId: dish.cuisineId,
                      itemId: dish.id,
                      name: dish.name,
                      imageUrl: dish.imageUrl,
                      price: double.parse(dish.price),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added to cart"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
