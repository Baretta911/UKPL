import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../providers/auth_provider.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productDetail = '/product/:id';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String feedback = '/feedback';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isLoggedIn;
      final isLoginRoute = state.matchedLocation == login || 
                          state.matchedLocation == register ||
                          state.matchedLocation == splash;

      // If not logged in and not on auth routes, redirect to login
      if (!isLoggedIn && !isLoginRoute) {
        return login;
      }

      // If logged in and on auth routes, redirect to home
      if (isLoggedIn && (state.matchedLocation == login || state.matchedLocation == register)) {
        return home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: search,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: feedback,
            builder: (context, state) => const FeedbackScreen(),
          ),
        ],
      ),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}
