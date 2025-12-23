import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:onebanc_application/authentication/signup_screen.dart';
import 'package:onebanc_application/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 56, left: 24, bottom: 24, right: 24),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage("assets/images/logo.png"),
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle().copyWith(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF6F6F6),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Discover Vast Variety of Cuisines",
                    style: TextStyle().copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFF6F6F6),
                    ),
                  ),
                ],
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.direct_right,
                            color: Colors.blue,
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.password_check,
                            color: Colors.blue,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon(
                            Iconsax.eye_slash,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                activeColor: Colors.blue.shade900,
                              ),
                              Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => SignupScreen()),
                            );
                          },
                          child: Text(
                            "Create Account",
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Or Sign In With",
                    style: TextStyle().copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/google-icon.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/facebook-icon.png"),
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
