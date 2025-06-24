import 'package:flutter/material.dart';

class AppColors {
  // Mint Color Palette
  static const Color mintPrimary = Color(0xFF4ECDC4);
  static const Color mintSecondary = Color(0xFF96E6B3);
  static const Color mintLight = Color(0xFFB8F2FF);
  static const Color mintDark = Color(0xFF2F8F8F);
  
  // Pastel Colors
  static const Color yellowPastel = Color(0xFFFFE5B4);
  static const Color pinkPastel = Color(0xFFFFB3C1);
  static const Color purplePastel = Color(0xFFC9B3FF);
  static const Color bluePastel = Color(0xFFB3D9FF);
  
  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Currency Colors (by location)
  static const Color indonesiaColor = Color(0xFFFF4444);
  static const Color usaColor = Color(0xFF0066CC);
  static const Color japanColor = Color(0xFFFF6600);
  static const Color londonColor = Color(0xFF800080);
  
  // Gradient Colors
  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintPrimary, mintSecondary],
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [yellowPastel, pinkPastel],
  );
  
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bluePastel, mintLight],
  );
}
