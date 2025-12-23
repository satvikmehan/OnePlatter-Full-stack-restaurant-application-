import 'package:flutter/material.dart';
import 'package:onebanc_application/authentication/login_screen.dart';


class Startingscreens extends StatefulWidget {
  const Startingscreens({super.key});

  @override
  State<Startingscreens> createState() => _StartingscreensState();
}

class _StartingscreensState extends State<Startingscreens>{
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> StartingData = [
    {
      "image": "assets/images/starting1.gif",
      "title": "Welcome to OnePlatter!!!",
      "desc": "Online Menu Card"
    },
    {
      "image": "assets/images/starting2.gif",
      "title": "Order and Pay Online",
      "desc": "Save Paper, Save Environment"
    },
    {
      "image": "assets/images/starting3.gif",
      "title": "Contactless Services",
      "desc": "Fast and Hassle Free Services"
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: StartingData.length,
            itemBuilder: (context, index) {
              return StartingPage(
                image: StartingData[index]["image"]!,
                title: StartingData[index]["title"]!,
                desc: StartingData[index]["desc"]!,
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _controller.jumpToPage(StartingData.length - 1);
                  },
                  child: Text("Skip",
                      style: TextStyle(fontSize: 18, color: Colors.blue)),
                ),
                Row(
                  children: List.generate(
                    StartingData.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentIndex == StartingData.length - 1) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    } else {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    }
                  },
                  child: Text(
                      _currentIndex == StartingData.length - 1
                          ? "Get Started"
                          : "Next",
                      style: TextStyle(fontSize: 18, color: Colors.blue)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StartingPage extends StatelessWidget {
  final String image, title, desc;

  const StartingPage(
      {super.key, required this.image, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, width: 300), // Placeholder for onboarding images
        SizedBox(height: 20),
        Text(title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.blue)),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(desc,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16,color: Colors.white)),
        ),
      ],
    );
  }
}