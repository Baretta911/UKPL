import 'package:flutter/material.dart';
import 'package:toko_mainan_flutter/pages/catalog_page.dart';
import 'package:toko_mainan_flutter/pages/branches_page.dart';
import 'package:toko_mainan_flutter/pages/status_page.dart';
import 'package:toko_mainan_flutter/pages/profile_page.dart';
import 'package:toko_mainan_flutter/pages/cart_page.dart'; // Import CartPage
import 'package:toko_mainan_flutter/services/cart_service.dart'; // Import CartService
import 'package:provider/provider.dart'; // Import Provider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of widgets to call for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    CatalogPage(), // Index 0: Main/Home (now CatalogPage)
    BranchesPage(), // Index 1: Branches (LBS)
    StatusPage(), // Index 2: Status (Feedback)
    ProfilePage(), // Index 3: Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const CatalogPage();
      case 1:
        return const BranchesPage();
      case 2:
        return const StatusPage(); // Assuming this is your feedback/status page
      case 3:
        return const ProfilePage();
      default:
        return const CatalogPage(); // Default to CatalogPage
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<CartService>().itemCount; // Watch cart item count

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Mainan'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                tooltip: 'Open Cart',
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // This will be the Catalog
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Branches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColorDark, // Example color
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // Good for visibility
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible and have labels
      ),
    );
  }
}
