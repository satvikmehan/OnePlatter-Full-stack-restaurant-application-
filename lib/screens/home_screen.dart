import 'package:flutter/material.dart';
import 'package:onebanc_application/global/gloabl.dart';
import 'package:onebanc_application/models/cuisine.dart';
import 'package:onebanc_application/screens/menu_screen.dart';
import 'package:onebanc_application/screens/pay_screen.dart';
import 'package:onebanc_application/screens/setting_screen.dart';
import 'package:onebanc_application/services/api_services.dart';
import 'package:onebanc_application/services/whole_menu_screen.dart';
import 'package:onebanc_application/widget/my_appbar.dart';
import 'package:onebanc_application/widget/top_dishes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Cuisine>? _cuisines;
  bool _isLoading = true;
  String? _error;

  List<Widget> getScreens() {
    return [
      _buildHomeGrid(),
      WholeMenuScreen(),
      PayScreen(
        onGoHome: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      SettingScreen(userName: "User"),
    ];
  }

  final PageController _pageController = PageController(
    initialPage: 5000,
    viewportFraction: 0.85,
  );

  int getCartItemCount() {
    return cart.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  void initState() {
    super.initState();
    _loadCuisines();
  }

  void _loadCuisines() async {
    try {
      final data = await ApiService.fetchCuisines();
      setState(() {
        _cuisines = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      body: IndexedStack(index: _currentIndex, children: getScreens()),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'All Dishes',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                ValueListenableBuilder<int>(
                  valueListenable: cartItemCount,
                  builder: (context, count, _) {
                    if (count == 0) return SizedBox(); // no badge
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeGrid() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text("Error: $_error"));
    }

    if (_cuisines == null || _cuisines!.isEmpty) {
      return Center(child: Text("No cuisines available."));
    }
    final cuisines = _cuisines!;
    final List<Dish> allDishes = cuisines.expand((c) => c.items).toList();
    allDishes.sort(
      (a, b) => double.parse(b.rating).compareTo(double.parse(a.rating)),
    );
    final topDishes = allDishes.take(3).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select Cuisine",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 10000,
              itemBuilder: (context, index) {
                final cuisine = cuisines[index % cuisines.length];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuScreen(cuisine: cuisine),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == cuisines.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(cuisine.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          cuisine.name,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Top 3 Famous Dishes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TopDishes(
            topDishes: topDishes,
            onCartChanged: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
