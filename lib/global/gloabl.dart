import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onebanc_application/models/cuisine.dart';

List<CartItem> cart=[];

ValueNotifier<int> cartItemCount = ValueNotifier(0);

void addToCart(CartItem item) {
  final existing = cart.indexWhere((e) => e.itemId == item.itemId);
  if (existing != -1) {
    cart[existing].quantity += item.quantity;
  } else {
    cart.add(item);
  }
  cartItemCount.value = cart.fold(0, (sum, item) => sum + item.quantity);
}

void removeFromCart(String itemId) {
  cart.removeWhere((item) => item.itemId == itemId);
  cartItemCount.value = cart.fold(0, (sum, item) => sum + item.quantity);
}
