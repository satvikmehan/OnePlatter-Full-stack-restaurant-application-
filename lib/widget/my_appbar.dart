import 'package:flutter/material.dart';


class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});

  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(140);
}

class _MyAppbarState extends State<MyAppbar>
    with SingleTickerProviderStateMixin{
      late AnimationController _glowController;
      late Animation<double> _glowAnimation;

  @override
  void initState(){
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(140),
      child: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 9, 144, 255).withOpacity(_glowAnimation.value),
                        const Color.fromARGB(255, 68, 215, 255).withOpacity(_glowAnimation.value)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png",height:75),
                SizedBox(width: 8),
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.bounceOut,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Text(
                    "OnePlatter",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  }

  class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 40, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}