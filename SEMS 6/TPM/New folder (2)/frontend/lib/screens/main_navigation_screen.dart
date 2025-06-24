import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/location_provider.dart';
import '../services/database_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _navigationItems = [
    {
      'icon': Icons.home_outlined,
      'selectedIcon': Icons.home,
      'label': 'Home',
      'route': '/home',
    },
    {
      'icon': Icons.search_outlined,
      'selectedIcon': Icons.search,
      'label': 'Search',
      'route': '/search',
    },
    {
      'icon': Icons.favorite_outline,
      'selectedIcon': Icons.favorite,
      'label': 'Favorites',
      'route': '/favorites',
    },
    {
      'icon': Icons.person_outline,
      'selectedIcon': Icons.person,
      'label': 'Profile',
      'route': '/profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.mintPrimary,
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: _navigationItems.map((item) {
              final index = _navigationItems.indexOf(item);
              final isSelected = index == _currentIndex;
              
              return BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.mintPrimary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected ? item['selectedIcon'] : item['icon'],
                        size: 24,
                      ),
                    ),
                    if (item['label'] == 'Favorites')
                      Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                          final favoriteCount = DatabaseService.getFavoriteProductIds().length;
                          if (favoriteCount > 0) {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  favoriteCount > 99 ? '99+' : favoriteCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                  ],
                ),
                label: item['label'],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to cart
          Navigator.of(context).pushNamed('/cart');
        },
        backgroundColor: AppColors.mintPrimary,
        child: Stack(
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  final cartCount = DatabaseService.getCartItemCount();
                  if (cartCount > 0) {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartCount > 99 ? '99+' : cartCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to the corresponding route
    final route = _navigationItems[index]['route'];
    Navigator.of(context).pushReplacementNamed(route);
  }
}
