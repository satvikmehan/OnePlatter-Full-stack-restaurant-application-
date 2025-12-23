import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/models/cuisine.dart';
import 'package:onebanc_application/services/api_services.dart';

class DishDetail extends StatelessWidget {
  final String itemId;


  const DishDetail({super.key,required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Dish>(
      future: ApiService.fetchDishById(itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
            content: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to load dish: ${snapshot.error}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        } else {
          final dish = snapshot.data!;
          return AlertDialog(
            title: Text(dish.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(dish.imageUrl, height: 150, fit: BoxFit.cover),
                const SizedBox(height: 8),
                Text("Price: ₹${dish.price}"),
                Text("Rating: ⭐ ${dish.rating}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Add to Cart"),
                onPressed: () {
                  addToCart(CartItem(
                    cuisineId: dish.cuisineId,
                    itemId: dish.id,
                    name: dish.name,
                    imageUrl: dish.imageUrl,
                    price: double.parse(dish.price),
                  ));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to cart"), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}