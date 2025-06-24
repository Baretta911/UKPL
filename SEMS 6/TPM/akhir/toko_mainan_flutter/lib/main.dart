import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:toko_mainan_flutter/pages/splash_screen.dart';
import 'package:toko_mainan_flutter/services/cart_service.dart'; // Import CartService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartService(), // Provide CartService
      child: MaterialApp(
        title: 'Toko Mainan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true, // Optional: Enable Material 3 for modern UI
        ),
        home: const SplashScreen(), // Your initial screen
        // Define routes if you have multiple pages for navigation
        // routes: {
        //   '/login': (context) => LoginPage(),
        //   '/home': (context) => HomePage(),
        //   // etc.
        // },
      ),
    );
  }
}
