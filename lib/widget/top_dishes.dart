import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/models/cuisine.dart';
import 'package:onebanc_application/widget/dish_detail.dart';

class TopDishes extends StatelessWidget {
  final List<Dish> topDishes;
  final VoidCallback onCartChanged;

  const TopDishes({
    super.key,
    required this.topDishes,
    required this.onCartChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: topDishes.length,
      itemBuilder: (context, index) {
        final dish = topDishes[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => DishDetail(itemId: dish.id),
              );
            },
            child: ListTile(
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
                  onCartChanged();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added to cart"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
