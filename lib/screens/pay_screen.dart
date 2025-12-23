import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/services/api_services.dart';

class PayScreen extends StatefulWidget {
  final VoidCallback onGoHome;

  const PayScreen({super.key,required this.onGoHome});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  double get subtotal =>
      cart.fold(0, (sum, item) => sum + item.total);
  double get cgst => subtotal * 0.025;
  double get sgst => subtotal * 0.025;
  double get grandTotal => subtotal + cgst + sgst;

  void increaseQt(int index) {
    setState(() {
      cart[index].quantity++;
      cartItemCount.value = cart.fold(0, (sum, item) => sum + item.quantity);
    });
  }

  void decreaseQt(int index) async {
    if (cart[index].quantity > 1) {
      setState(() {
        cart[index].quantity--;
        cartItemCount.value = cart.fold(0, (sum, item) => sum + item.quantity);
      });
    } else {
      bool confirm = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Remove Item"),
              content: Text(
                "Are you sure you want to remove this item from the cart?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Yes"),
                ),
              ],
            ),
      );

      if (confirm) {
        setState(() {
          cart.removeAt(index);
          cartItemCount.value = cart.fold(0, (sum, item) => sum + item.quantity);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Item Removed from cart"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _confirmClearCart() async {
    bool confirm = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Clear Cart"),
            content: Text(
              "Are you sure you want to remove all items from the cart?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes"),
              ),
            ],
          ),
    );

    if (confirm) {
      setState(() {
        cart.clear();
        cartItemCount.value = 0;
      });
      widget.onGoHome();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cart emptied"), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          cart.isEmpty
              ? Center(child: Text("Your cart is empty."))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: _confirmClearCart,
                      icon: Icon(Icons.delete_forever, color: Colors.red),
                      label: Text(
                        "Empty All",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.name),
                            subtitle: Text("₹${item.price} x ${item.quantity}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () => decreaseQt(index),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () => increaseQt(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Subtotal: ₹${subtotal.toStringAsFixed(2)}"),
                        Text("CGST (2.5%): ₹${cgst.toStringAsFixed(2)}"),
                        Text("SGST (2.5%): ₹${sgst.toStringAsFixed(2)}"),
                        SizedBox(height: 8),
                        Text(
                          "Total: ₹${grandTotal.toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final result = await ApiService.placeOrder(
                                cart,
                              );
                              final txnRef = result['txn_ref_no'];

                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text('Order Placed!'),
                                      content: Text('Transaction ID: $txnRef'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              cart.clear();
                                              cartItemCount.value = 0;
                                            });
                                            Navigator.pop(context);
                                            widget.onGoHome();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to place order: $e"),
                                ),
                              );
                            }
                          },
                          child: Text("Place Order"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
