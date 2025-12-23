import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onebanc_application/screens/splash_screen.dart';
import 'package:onebanc_application/widget/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: OnePlatter(),
    ),
  );
}

Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAlZBcaqdQ1h-Z0ovBDt1ZCAUkjBSB6QLg",
          authDomain: "oneplatter-94b18.firebaseapp.com",
          projectId: "oneplatter-94b18",
          storageBucket: "oneplatter-94b18.appspot.com",
          messagingSenderId: "439890686878",
          appId: "1:439890686878:web:efd74e6268beeafad9dc8f",
          measurementId: "G-DV7FW8JF6J",
        ),
      );
    }
  } catch (e) {
    print("Firebase init error: $e");
  }
}

class OnePlatter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor:
                themeProvider.isDarkMode ? Colors.black : Colors.white,
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
