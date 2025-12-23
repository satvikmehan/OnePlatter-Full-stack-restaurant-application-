import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/models/cuisine.dart';
import 'package:onebanc_application/services/api_services.dart';
import 'package:onebanc_application/widget/dish_detail.dart';

class WholeMenuScreen extends StatefulWidget {
  const WholeMenuScreen({super.key});

  @override
  State<WholeMenuScreen> createState() => _WholeMenuScreenState();
}

class _WholeMenuScreenState extends State<WholeMenuScreen> {
  List<Dish> allDishes = [];
  List<Dish> originalDishes = [];
  List<Cuisine> cuisineList = [];
  bool isLoading = true;
  List<String> selectedCuisines = [];
  String? _sortBy;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadAllDishes();
    _fetchCuisines();
  }

  void _fetchCuisines() async {
    try {
      final cuisines = await ApiService.fetchCuisines();
      setState(() {
        cuisineList = cuisines;
      });
    } catch (e) {}
  }

  void _loadAllDishes() async {
    try {
      final result = await ApiService.fetchAllDishes();
      setState(() {
        allDishes = result;
        originalDishes = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Cuisine",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children:
                        cuisineList.map((cuisine) {
                          final isSelected = selectedCuisines.contains(
                            cuisine.name,
                          );
                          return FilterChip(
                            label: Text(cuisine.name),
                            selected: isSelected,
                            onSelected: (val) {
                              setModalState(() {
                                if (val) {
                                  selectedCuisines.add(cuisine.name);
                                } else {
                                  selectedCuisines.remove(cuisine.name);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: Text("Apply"),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: Text("Reset", style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _applyFilters() async {
    if (selectedCuisines.isEmpty) {
      _loadAllDishes();
      return;
    }

    setState(() => isLoading = true);
    try {
      final filtered = await ApiService.fetchFilteredDishes(
        cuisineTypes: selectedCuisines,
      );
      setState(() {
        allDishes = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _resetFilters() {
    Navigator.pop(context);
    setState(() {
      selectedCuisines.clear();
      _sortBy = null;
      isLoading = true;
      allDishes = List.from(originalDishes);
    });
    _loadAllDishes();
  }

  void _sortDishes() {
    if (_sortBy == null) return;

    setState(() {
      allDishes.sort((a, b) {
        double valA =
            _sortBy == 'price' ? double.parse(a.price) : double.parse(a.rating);
        double valB =
            _sortBy == 'price' ? double.parse(b.price) : double.parse(b.rating);
        return _isAscending ? valA.compareTo(valB) : valB.compareTo(valA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Dishes"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle') {
                _isAscending = !_isAscending;
              } else {
                _sortBy = value;
              }
              _sortDishes();
            },
            icon: Icon(Icons.sort),
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'price', child: Text('Sort by Price')),
                  PopupMenuItem(value: 'rating', child: Text('Sort by Rating')),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          _isAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                        SizedBox(width: 8),
                        Text(_isAscending ? "Ascending" : "Descending"),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : allDishes.isEmpty
              ? Center(child: Text("No dishes found"))
              : ListView.builder(
                itemCount: allDishes.length,
                itemBuilder: (context, index) {
                  final dish = allDishes[index];
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
